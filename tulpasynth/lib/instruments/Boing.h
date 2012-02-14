/**
 *  @file       Boing.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#ifndef _BOING_H_
#define _BOING_H_

#include "RAMpler.hpp"

namespace instruments {


    /**
     *  @class      boing sound, used for ball collisions.
     *  @extends    instruments::RAMpler
     **/
    class Boing : protected RAMpler
    {
    public:
        Boing();
        ~Boing(){};

        virtual void play() {
            return RAMpler::play();
        }

        virtual stk::StkFloat next_samp(int channel) {
            return RAMpler::next_samp(channel);
        }

        virtual stk::StkFrames& next_buf(stk::StkFrames& frames, double nextBufferT) {
            return RAMpler::next_buf(frames, nextBufferT);
        }
    };
    
}

#endif