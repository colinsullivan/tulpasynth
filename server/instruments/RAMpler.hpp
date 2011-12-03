/**
 *  @file       RAMpler.hpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#ifndef _RAMPLER_HPP_
#define _RAMPLER_HPP_

#include <Stk.h>
#include <FileWvIn.h>

#include "Instrument.hpp"

namespace instruments {
    class RAMpler : private Instrument
    {
    public:
        /**
         *  Create a `RAMpler` object.
         **/
        RAMpler(Orchestra* anOrch, Json::Value initialAttributes);
        ~RAMpler(){};

        /**
         *  Helper method to reset `mPlaying` and `mClip` if we've finished
         *  playing the clip.
         **/
        void _reset_if_needed();


        virtual void play() {
            this->mPlaying = true;
            return;
        }

        virtual stk::StkFloat next_samp(int channel);
        virtual stk::StkFrames& next_buf(stk::StkFrames& frames);
    
    private:
        /**
         *  Clip to play
         **/
        stk::FileWvIn* mClip;
        
        /**
         *  If we are currently playing the sample
         **/
        bool mPlaying;
    };    
};
#endif