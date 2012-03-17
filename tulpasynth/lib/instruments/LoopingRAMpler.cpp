/**
 *  @file       LoopingRAMpler.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#include "LoopingRAMpler.hpp"

instruments::LoopingRAMpler::LoopingRAMpler() {
    
}

void instruments::LoopingRAMpler::set_clip(std::string clipPath) {
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

stk::StkFrames& instruments::LoopingRAMpler::next_buf(stk::StkFrames& frames) {
    
    if(this->mPlaying) {
        
        // Grab samples from clip using loop tick function
        stk::FileLoop::tick(frames);
    }
    
    return frames;
}


void instruments::LoopingRAMpler::freq(stk::StkFloat aFreq) {
    instruments::Instrument::freq(aFreq);
    
    FileLoop::setRate(FileLoop::file_.fileSize() * aFreq / Stk::sampleRate());
}

unsigned long instruments::LoopingRAMpler::duration() {
    if (this->file_.isOpen()) {
        return this->getSize();
    }
    else {
        return NULL;
    }
}
float instruments::LoopingRAMpler::percentComplete() {
    return (time_ / this->getSize());    
}

