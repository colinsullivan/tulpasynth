/**
 *  @file       RAMpler.hpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#ifndef _RAMPLER_HPP_
#define _RAMPLER_HPP_

#include <string.h>

#include "Stk.h"
#include "FileLoop.h"

#include "Instrument.hpp"

namespace instruments {

    /**
     *  @class      A sampler which keeps audio in RAM.
     *  @extends    instruments::Instrument
     **/
    class RAMpler : protected Instrument, protected stk::FileLoop
    {
    public:
        /**
         *  Create a `RAMpler` object.
         **/
        RAMpler(/*Orchestra* anOrch, Json::Value initialAttributes*/){};
        ~RAMpler() {
        };

        /**
         *  Set clip to use
         **/
        void set_clip(std::string clipPath);

        /**
         *  Helper method to reset `mPlaying` and `mClip` if we've finished
         *  playing the clip.
         **/
        void _reset_if_needed();


        virtual void play() {
            return Instrument::play();
        };
        
        virtual bool playing() {
            return Instrument::playing();
        }
        
        virtual void freq(stk::StkFloat aFreq);


        
        
//        virtual stk::StkFloat next_samp(int channel);
        virtual stk::StkFrames& next_buf(stk::StkFrames& frames);
        
        /**
         *  Getter for currently loaded sample duration.
         **/
        unsigned long duration();    
        
        /**
         *  Percent of sample currently played
         **/
        float percentComplete();
        
        virtual void finish_initializing() {
            Instrument::finish_initializing();
        }
    };    
};
#endif