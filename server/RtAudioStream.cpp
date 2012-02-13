/**
 *  @file       RtAudioStream.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *  
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/
#include <cstdlib>
#include <iostream>


#include "Globals.h"
#include "RtAudioStream.h"


RtAudioStream::RtAudioStream() {

    this->t = 0;
    this->bufferFrames = 1024;

    
    // Ensure there is an audio device available
    if(this->adac.getDeviceCount() < 1)
    {
        handle_error_and_exit("no audio devices found!");
    }

    // let RtAudio print messages to stderr.
    this->adac.showWarnings(true);
}

void RtAudioStream::init(RtAudioCallback callback) {
    // set input and output parameters
    RtAudio::StreamParameters iParams, oParams;
    iParams.deviceId = this->adac.getDefaultInputDevice();
    iParams.nChannels = CHANNELS;
    iParams.firstChannel = 0;
    oParams.deviceId = this->adac.getDefaultOutputDevice();
    oParams.nChannels = CHANNELS;
    oParams.firstChannel = 0;

    // create stream options
    RtAudio::StreamOptions options;

    unsigned int bufferFrames = this->bufferFrames;

    try {
        // open a stream
        adac.openStream(
            &oParams,
            &iParams,
            RTAUDIO_FLOAT64,
            SAMPLE_RATE,
            &bufferFrames,
            callback,
            NULL,
            &options
        );
    }
    catch( RtError& e )
    {
        this->handle_error_and_exit(e);
    }

    if(bufferFrames != this->bufferFrames) {
        this->bufferFrames = bufferFrames;
    }

}


void RtAudioStream::start() {
    try {
        // start stream
        adac.startStream();
        
    }
    catch( RtError& e )
    {
        this->handle_error_and_exit(e);
    }    
}

void RtAudioStream::stop() {
    this->cleanup();
}

void RtAudioStream::handle_error_and_exit(std::string errorMessage) {
    std::cerr << "Error: " << errorMessage << std::endl;

    std::cout << "Exiting...Bye!" << std::endl;
    exit(1);
}

void RtAudioStream::handle_error_and_exit(RtError& e) {
    this->handle_error_and_exit(e.getMessage());
}

void RtAudioStream::cleanup() {
    if(this->adac.isStreamOpen()) {
        std::cout << "Closing stream" << std::endl;
        this->adac.closeStream();   
    }
}

RtAudioStream::~RtAudioStream() {
    this->cleanup();
}
