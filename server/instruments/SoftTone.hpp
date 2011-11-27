/**
 *  @file       SoftTone.hpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/


#ifndef _SOFTTONE_HPP_
#define _SOFTTONE_HPP_

#include <BlowHole.h>

#include "Instrument.hpp"

namespace instruments {

/**
 *  @class  TODO: Description of sound.
 **/
class SoftTone : private Instrument, public stk::BlowHole
{
public:
    // SoftTone(stk::StkFloat lowestFrequency) : stk::BlowHole(lowestFrequency){};
    SoftTone(Orchestra* anOrch, Json::Value initialAttributes, stk::StkFloat lowestFrequency);
    ~SoftTone(){};

    virtual void play() {
        this->noteOn(220.0, 0.75);
    };

    virtual stk::StkFrames& next_buf(stk::StkFrames& frames, unsigned int channel) {
        return this->tick(frames, channel);
    };
};

}; //namespace instruments

#endif