/**
 *  @file       sound_server.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#include <math.h>
#include <vector>
#include <iostream>

#include <websocketpp.hpp>
#include <boost/asio.hpp>
#include <tclap/CmdLine.h>
#include <json/value.h>
#include <json/writer.h>

#include "socket_handler.hpp"
#include "RtAudioStream.h"

#include "Orchestra.hpp"

#include "instruments/Glitch.hpp"
#include "instruments/SoftTone.hpp"


using boost::asio::ip::tcp;

socket_handler* sockets;

RtAudioStream* audio;

/*  Singleton `Orchestra` instance for handling time
    and instrument encapsulation */
Orchestra* orchestra;

// Test
instruments::SoftTone* s;
bool sPlayed = false;

/**
 *  Interval at which to update clients
 **/
int SYNC_UPDATE_INTERVAL = floor(0.1*SAMPLE_RATE);

/**
 *  Last time we sent a sync message (sample number)
 **/
int g_lastsync_t = 0;

/**
 *  Global sample counter
 **/
int g_t = 0;


/**
 *  Helper method to copy audio from channel one into
 *  other channels.
 *
 *  @param  output      The buffer we are manipulating.
 *  @param  numFrames   Number of audio frames in buffer.
 **/
void copy_channels(SAMPLE output[], const unsigned int numFrames) {
    /* For each frame */
    for( unsigned int i = 0; i < numFrames; i++ ) {

        /* For each channel */
        for( int j = 1; j < CHANNELS; j++ ) {
            /* Copy audio from first channel */
            output[i*CHANNELS+j] = output[i*CHANNELS];            
        }
    }
}

int callback( void * outputBuffer, void * inputBuffer, unsigned int numFrames,
            double streamTime, RtAudioStreamStatus status, void * data )
{    
    // Message we will send over websocket
    std::stringstream msg;

    /* Zero output buffer */
    SAMPLE* outputSamples = (SAMPLE*)outputBuffer;
    for(unsigned int i = 0; i < numFrames; i++) {
        for(int c = 0; c < CHANNELS; c++) {
            outputSamples[i*CHANNELS+c] = 0.0;
        }
    }

    if(g_t > SAMPLE_RATE*3 && !sPlayed) {
        std::cout << "playing test" << std::endl;
        s->play();
        sPlayed = true;
    }


    // Get all instruments
    std::vector<instruments::Instrument*>* instrs = orchestra->get_instruments();

    // Get start time of next buffer (relative to loop duration)
    int loopDuration = orchestra->get_duration();
    double nextFrameT = (double)((g_t+numFrames)%loopDuration)/loopDuration;

    StkFrames* tempFrames = NULL;

    // For each instrument
    for(unsigned int j = 0; j < instrs->size(); j++) {
        instruments::Instrument* instr = (*instrs)[j];

        // Temporary output buffer
        tempFrames = new StkFrames(0.0, numFrames, CHANNELS);

        // If instrument should be triggered during this buffer
        double startTime = instr->get_attributes()["startTime"].asDouble();
        double now = orchestra->get_t();
        if(
            (
                // Start time is now
                startTime == now
                ||
                // Start time is later but before next buffer
                (startTime > now && startTime < nextFrameT)
            // And instrument is not "disabled"
            ) && !instr->get_attributes()["disabled"].asBool()
        ) {
            // Play instrument
            std::cout << "playing instrument #" << instr->get_id() << std::endl;
            instr->play();
        }


        // Pull samples off of instrument wether it is playing or not.
        for(unsigned int i = 0; i < CHANNELS; i++) {
            instr->next_buf((*tempFrames), i);
            // Add samples to master output for this channel
            for(int k = 0; k < numFrames; k++) {
                outputSamples[k*CHANNELS+i] += (*tempFrames)[k*CHANNELS+i];
            }
        }

        // Clear tempFrames
        delete tempFrames;
    }



    // increment global sample counter
    g_t += numFrames;

    // Update loop position
    orchestra->set_t(nextFrameT);


    // Send loop position to all connected clients every `SYNC_UPDATE_INTERVAL` samples.
    if((g_t-g_lastsync_t) > SYNC_UPDATE_INTERVAL) {
        // Keep track of when we last sent sync messages to clients
        g_lastsync_t = g_t;

        // Create JSON response
        Json::Value resp;
        resp["method"] = "update";
        resp["namespace"] = "hwfinal.models.Orchestra";
        resp["attributes"]["id"] = "1";
        resp["attributes"]["t"] = orchestra->get_t();

        Json::StyledWriter writer;
        std::string msg = writer.write(resp);
        // std::cout << "Sending:\n" << msg << std::endl;
        sockets->send_to_all(msg);
    }    
    return 0;
}

/**
 *  Handle kill signal properly.  Tells StreamGenerator to
 *  stop before exiting.
 *
 *  @param  signum  Integer representation of signal as defined in
 *  POSIX or whatever.
 **/
void signal_callback_handler(int signum) {
    std::cout << "Killed by user." << std::endl;
    audio->stop();
    std::cout << "Exiting...Bye!" << std::endl;
    exit(signum);
}


int main(int argc, char* argv[]) {

    /* When program is killed, handle properly */
    signal(SIGINT, signal_callback_handler);

    /* Host and port to bind websocket server to */
    std::string host;
    short port;

    /* Parse command line arguments */
    try {
        TCLAP::CmdLine cmd(
            "Server for hwfinal, the collaborative music making tool.",
            ' ',
            "0.1"
        );

        TCLAP::ValueArg<std::string> hostArg(
            "a",
            "address",
            "The IP address to bind the websocket server to.",
            false,
            // Default IP
            "192.168.179.214",
            "std::string",
            cmd
        );

        TCLAP::ValueArg<short> portArg(
            "p",
            "port",
            "The port to bind the websocket server to.",
            false,
            // Default port
            9090,
            "short",
            cmd
        );

        cmd.parse(argc, argv);

        host = hostArg.getValue();
        port = portArg.getValue();
    } catch(TCLAP::ArgException &e) {
        std::cerr << "Error while parsing arguments: " << e.error() << std::endl;
    }


	/* Initialize stream generator object for creating sounds */
    audio = new RtAudioStream();

    /* Initialize `Orchestra` to encapsulate composition */
    orchestra = new Orchestra();

	std::string full_host;		
	std::stringstream temp;
	
	temp << host << ":" << port;
	full_host = temp.str();

	sockets = new socket_handler(orchestra);


	try {
		boost::asio::io_service io_service;
		tcp::endpoint endpoint(tcp::v6(), port);
		
		websocketpp::server_ptr server(
			new websocketpp::server(io_service,endpoint,boost::shared_ptr<socket_handler>(sockets))
		);
		
		// setup server settings
		server->add_host("localhost");
        server->add_host(host);
		server->add_host(full_host);
		// Chat server should only be receiving small text messages, reduce max
		// message size limit slightly to save memory, improve performance, and 
		// guard against DoS attacks.
		server->set_max_message_size(0xFFFF); // 64KiB

        // Tell stk where to get its raw wave files
        stk::Stk::setRawwavePath("./instruments/samples/");

        // Tell stk what sample rate we're using
        stk::Stk::setSampleRate(SAMPLE_RATE);
		
		// start the server
		server->start_accept();

		
		// Start audio generator
	    audio->init(callback);

        Json::Value attributes;
        attributes["id"] = orchestra->generate_instrument_id();
        attributes["disabled"] = true;
        s = new instruments::SoftTone(orchestra, attributes, 20);


		std::cout << "Starting sound server on " << full_host << std::endl;

        audio->start();		
		io_service.run();


	} catch (std::exception& e) {
		std::cerr << "Exception: " << e.what() << std::endl;
	}
	
	return 0;
}
