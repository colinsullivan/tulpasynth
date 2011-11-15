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

#include "socket_handler.hpp"
#include "RtAudioStream.h"

#include "instruments/Glitch.hpp"


using boost::asio::ip::tcp;

socket_handler* sockets;

RtAudioStream* audio;

// Vector to hold all instruments
std::vector<stk::Instrmnt*> instrs;

// Vector to hold output buffers for each instrument.
std::vector<stk::StkFrames*> instrumentBuffers;




/**
 *  Loop duration in samples
 **/
int LOOP_DURATION = 4*SAMPLE_RATE;

/**
 *  Interval at which to update clients
 **/
int SYNC_UPDATE_INTERVAL = floor(0.1*SAMPLE_RATE);

/**
 *  Last time we sent a sync message
 **/
int g_lastsync_t = 0;



SAMPLE g_freq = 440;
int g_t = 0;

// Our current position relative to loop (percentage)
double g_loop_t = 0.0;

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
    SAMPLE* outputSamples = (SAMPLE *)outputBuffer;
    for(unsigned int i = 0; i < numFrames; i++) {
        outputSamples[i*CHANNELS] = 0;
    }


    /* For each instrument */
    for(unsigned int i = 0; i < instrs.size(); i++) {
        stk::Instrmnt* instr = instrs[i];
        stk::StkFrames* instrOutput = instrumentBuffers[i];

        // Generate output
        instr->tick((*instrOutput), 0);

        // Add to output buffer
        for(unsigned int i = 0; i < numFrames; i++) {
            outputSamples[i*CHANNELS] += (float)(*instrOutput)[i];
        }
    }

    // copy into other channels
    copy_channels(outputSamples, numFrames);


    // increment sample number
    g_t += numFrames;

    // Update loop position
    g_loop_t = (double)(g_t % LOOP_DURATION)/LOOP_DURATION;

    // Send loop position to all connected clients every `SYNC_UPDATE_INTERVAL` samples.
    if((g_t-g_lastsync_t) > SYNC_UPDATE_INTERVAL) {
        g_lastsync_t = g_t;
        msg << "{\"type\":\"sync\", \"t\":" << g_loop_t << "}";
        // std::cout << "Sending:\n" << msg.str() << std::endl;
        sockets->send_to_all(msg.str());
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

	/* Initialize stream generator object for creating sounds */
    audio = new RtAudioStream();

	std::string host = "192.168.179.214";
	short port = 9090;
	std::string full_host;
	
	if (argc == 3) {
		// TODO: input validation?
		host = argv[1];
		port = atoi(argv[2]);
	}
		
	std::stringstream temp;
	
	temp << host << ":" << port;
	full_host = temp.str();

	sockets = new socket_handler(&instrs);




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

        // Set up instruments

        // Tell stk where to get its raw wave files
        stk::Stk::setRawwavePath("./instruments/samples/");

        // Create 8 glitches for now
        for(int i = 0; i < 8; i++) {
            instrs.push_back(new instruments::Glitch(14));
        }

        // And create buffers for each 
        for(unsigned int i = 0; i < instrs.size(); i++) {
            instrumentBuffers.push_back(new stk::StkFrames(audio->getBufferFrames(), CHANNELS));
        }


		
		// start the server
		server->start_accept();
		
		// Start audio generator
	    audio->init(callback);


		std::cout << "Starting sound server on " << full_host << std::endl;

        audio->start();		
		io_service.run();
	} catch (std::exception& e) {
		std::cerr << "Exception: " << e.what() << std::endl;
	}
	
	return 0;
}
