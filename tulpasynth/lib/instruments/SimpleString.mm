/**
 *  @file       SimpleString.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#include "SimpleString.hpp"

instruments::SimpleString::SimpleString() : instruments::Instrument() {    
    _karp = new stk::StifKarp(110);

    _karp->setFrequency(440);
    
    _noteDuration = stk::SRATE*1;
}

instruments::SimpleString::~SimpleString() {
    delete _karp;
}

void instruments::SimpleString::play() {
    Instrument::play();

    this->_karp->pluck(0.8);
    _playingFor = 0;
};


stk::StkFloat instruments::SimpleString::next_samp(int channel) {
    //unused currently
}

stk::StkFrames& instruments::SimpleString::next_buf(stk::StkFrames& frames, double nextBufferT) {
    // Karp renders mono 
    for (int i = 0; i < frames.frames(); i++) {
        frames[i*2+0] = frames[i*2+1] = this->_karp->tick();
    }

    // if we're currently playing
    if (mPlaying) {
        // keep track of how long we've been playing for
        _playingFor += frames.frames();
        
        // if we should be done playing
        if (_playingFor >= _noteDuration) {
            // note off
            this->_karp->noteOff(0.5);
        }
        mPlaying = false;
    }
    return frames;
}

void instruments::SimpleString::freq(float aFreq) {
    this->_karp->setFrequency(aFreq);
}