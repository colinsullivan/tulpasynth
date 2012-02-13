

#include <websocketpp.hpp>
#include <boost/asio.hpp>

#include "sound.hpp"
#include "RtAudioStream.h"

#include <iostream>

using boost::asio::ip::tcp;
using namespace socketsound;

socket_sound_handler* sound_handler;

RtAudioStream* audio;
SAMPLE g_freq = 440;
SAMPLE g_t = 0;
float periodLength = 1 / (g_freq / SAMPLE_RATE);

int callback( void * outputBuffer, void * inputBuffer, unsigned int numFrames,
            double streamTime, RtAudioStreamStatus status, void * data )
{
    // debug print something out per callback
    // std::cerr << ".";

    // Create new audio buffer which will hold our results
    SAMPLE * buffy = new SAMPLE[numFrames*CHANNELS];
    SAMPLE* output = (SAMPLE*)outputBuffer;
    // SAMPLE * input = (SAMPLE *)inputBuffer;
    
    // Message we will send over websocket
    std::stringstream msg;

    msg << "{\"type\":\"buf\",\"numFrames\":" 
    	<< numFrames
    	<< ",\"samples\":[";

    // fill
    for( int i = 0; i < numFrames; i++ )
    {
    	// Don't need to play audio on the server!
    	output[i*CHANNELS] = 0;

        /* Amount of samples since the last period */
        int samplesSinceLastPeriod = int(g_t) % int(periodLength);

        // generate signal
        buffy[i*CHANNELS] = sin( 2 * PI * g_freq * g_t / SAMPLE_RATE );

        msg << buffy[i*CHANNELS];

        if(i < numFrames-1) {
        	msg << ",";
        }

        // copy into other channels
        for( int j = 1; j < CHANNELS; j++ )
            buffy[i*CHANNELS+j] = buffy[i*CHANNELS];
            
        // increment sample number
        g_t += 1.0;

        // Increase frequency
        g_freq += sin(PI/16 * g_t/SAMPLE_RATE);
    }

    // Send buffer to all connected socket clients
    msg << "]}";
    sound_handler->send_to_all(msg.str());
    
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

	std::string host = "localhost";
	short port = 9003;
	std::string full_host;
	
	if (argc == 3) {
		// TODO: input validation?
		host = argv[1];
		port = atoi(argv[2]);
	}
		
	std::stringstream temp;
	
	temp << host << ":" << port;
	full_host = temp.str();

	sound_handler = new socket_sound_handler();




	try {
		boost::asio::io_service io_service;
		tcp::endpoint endpoint(tcp::v6(), port);
		
		websocketpp::server_ptr server(
			new websocketpp::server(io_service,endpoint,boost::shared_ptr<socket_sound_handler>(sound_handler))
		);
		
		// setup server settings
		server->add_host(host);
		server->add_host(full_host);
		// Chat server should only be receiving small text messages, reduce max
		// message size limit slightly to save memory, improve performance, and 
		// guard against DoS attacks.
		server->set_max_message_size(0xFFFF); // 64KiB
		
		// start the server
		server->start_accept();
		
		// Start audio generator
	    audio->start(callback);

		std::cout << "Starting sound server on " << full_host << std::endl;
		
		io_service.run();
	} catch (std::exception& e) {
		std::cerr << "Exception: " << e.what() << std::endl;
	}
	
	return 0;
}
