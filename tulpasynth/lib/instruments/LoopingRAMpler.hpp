/**
 *  @file       LoopingRAMpler.hpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#ifndef _LOOPINGRAMPLER_H_
#define _LOOPINGRAMPLER_H_

#include "RAMpler.hpp"
#include "FileLoop.h"

namespace instruments {

    class LoopingRAMpler : protected Instrument, protected stk::FileLoop
    {
    public:
        LoopingRAMpler();
        ~LoopingRAMpler(){};
        
        virtual stk::StkFrames& next_buf(stk::StkFrames& frames);
        
        /**
         *  Set frequency of loop
         **/
        virtual void freq(stk::StkFloat aFreq);
        
        virtual void set_clip(std::string clipPath);
        
        virtual void finish_initializing() {
            Instrument::finish_initializing();
        }
        
        virtual void play() {
            return Instrument::play();
        }
        virtual float percentComplete();
        
        unsigned long duration();
        virtual void reset() {
            return FileLoop::reset();
        }
    };    
}


#endif