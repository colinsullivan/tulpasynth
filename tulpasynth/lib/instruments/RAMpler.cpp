/**
 *  @file       RAMpler.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#include "RAMpler.hpp"

//instruments::RAMpler::RAMpler(/*Orchestra* anOrch, Json::Value initialAttributes*/) : instruments::Instrument::Instrument(/*anOrch, initialAttributes*/), stk::FileWvIn() {
//
//    return;
//};

void instruments::RAMpler::set_clip(std::string clipPath) {
    // Load clip
//    this->mClip = new stk::FileWvIn(clipPath);
    this->openFile(clipPath, false, true);

    // If clip is large
    unsigned long fileSize = this->getSize();
    if(fileSize > chunkThreshold_) {
        this->closeFile();
        
        // Load again with larger chuckThreshold to ensure it
        // stays in RAM.
        chunkThreshold_ = fileSize+1;
        this->openFile(clipPath, false, true);
    }
}

//stk::StkFloat instruments::RAMpler::next_samp(int channel) {
//    stk::StkFloat result = 0;
//
//    if(this->mPlaying) {
//        result = this->mClip->tick(channel);
//        this->_reset_if_needed();
//
//    }
//
//    return result;
//}

stk::StkFrames& instruments::RAMpler::next_buf(stk::StkFrames& frames) {
    
    if(this->mPlaying) {
        
        // Grab samples from clip
        this->tick(frames);            
        
        // If we've finished playing clip
        if(this->isFinished()) {
            // we're no longer playing
            this->mPlaying = false;
            // Reset clip to beginning
            this->reset();
        }

    }

    return frames;
}


unsigned long instruments::RAMpler::duration() {
    if (this->file_.isOpen()) {
        return this->getSize();
    }
    else {
        return NULL;
    }
}
float instruments::RAMpler::percentComplete() {
    return (time_ / this->getSize());    
}


void instruments::RAMpler::play() {
    Instrument::play();
    
//    this->reset();
}

void instruments::RAMpler::freq(stk::StkFloat aFreq) {
    Instrument::freq(aFreq);

    FileWvIn::setRate(FileWvIn::file_.fileSize() * aFreq / Stk::sampleRate());
}
