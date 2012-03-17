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
    class RAMpler : protected Instrument, protected stk::FileWvIn
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
        virtual void set_clip(std::string clipPath);


        virtual void play();
        
        virtual bool playing() {
            return Instrument::playing();
        }
                
        virtual void reset() {
            return FileWvIn::reset();
        }
        
        virtual void stop() {
            return Instrument::stop();
        }
        
//        virtual stk::StkFloat next_samp(int channel);
        virtual stk::StkFrames& next_buf(stk::StkFrames& frames);
        
        /**
         *  Getter for currently loaded sample duration.
         **/
        unsigned long duration();    
        
        /**
         *  Percent of sample currently played
         **/
        virtual float percentComplete();
        
        virtual void finish_initializing() {
            Instrument::finish_initializing();
        }
        
        
    };    
};
#endif