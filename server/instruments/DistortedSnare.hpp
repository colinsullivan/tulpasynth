/**
 *  @file       DistortedSnare.hpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#ifndef _DISTORTEDSNARE_HPP_
#define _DISTORTEDSNARE_HPP_

#include "RAMpler.hpp"

namespace instruments {
    class DistortedSnare : protected RAMpler
    {
    public:
        DistortedSnare(Orchestra* anOrch, Json::Value initialAttributes);
        ~DistortedSnare() {};

        virtual void play() {
            return RAMpler::play();
        };

        virtual stk::StkFloat next_samp(int channel) {
            return RAMpler::next_samp(channel);
        };

        virtual stk::StkFrames& next_buf(stk::StkFrames& frames, double nextBufferT) {
            return RAMpler::next_buf(frames, nextBufferT);
        };

    };
}; //namespace instruments

#endif