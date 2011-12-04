/**
 *  @file       RAMpler.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#include "RAMpler.hpp"

instruments::RAMpler::RAMpler(Orchestra* anOrch, Json::Value initialAttributes) : instruments::Instrument::Instrument(anOrch, initialAttributes) {
    return;
};

void instruments::RAMpler::set_clip(std::string clipPath) {
    // Load clip
    this->mClip = new stk::FileWvIn(clipPath);

    // If clip is large
    unsigned long fileSize = this->mClip->getSize();
    if(fileSize > 1000000) {
        // Close and delete `FileWvIn` instance
        this->mClip->closeFile();
        delete this->mClip;

        // Load again with larger chuckThreshold to ensure it
        // stays in RAM.
        this->mClip = new stk::FileWvIn(clipPath, false, true, fileSize+1);
    }
}

stk::StkFloat instruments::RAMpler::next_samp(int channel) {
    stk::StkFloat result = 0;

    if(this->mPlaying) {
        result = this->mClip->tick(channel);
        this->_reset_if_needed();

    }

    return result;
}

stk::StkFrames& instruments::RAMpler::next_buf(stk::StkFrames& frames) {
    
    if(this->mPlaying) {
        // Grab samples from clip
        this->mClip->tick(frames);

        this->_reset_if_needed();
    }

    return frames;
}

void instruments::RAMpler::_reset_if_needed() {
    // If we've finished playing clip
    if(this->mClip->isFinished()) {
        // we're no longer playing
        this->mPlaying = false;
        // Reset clip to beginning
        this->mClip->reset();
    }
    
}