/**
 *  @file       Bubbly.hpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/


#ifndef _SOFTTONE_HPP_
#define _SOFTTONE_HPP_

// #include <algorithm>

#include <Stk.h>
#include <BiQuad.h>


#include "Instrument.hpp"
#include "../Globals.h"

namespace instruments {

/**
 *  @class  TODO: Description of sound.
 **/
class Bubbly : private Instrument
{
public:
    // Bubbly(stk::StkFloat lowestFrequency) : stk::BlowHole(lowestFrequency){};
    Bubbly(Orchestra* anOrch, Json::Value initialAttributes);
    ~Bubbly(){};

    virtual void play() {
        for(unsigned int i = 0; i < CHANNELS; i++) {
            (*this->nextSamplePerChannel[i]) = 1.0;
        }
    };

    void freq(stk::StkFloat aFreq);

    /**
     *  Generate the next audio buffer
     **/
    virtual stk::StkFrames& next_buf(stk::StkFrames& frames);
private:
    stk::StkFloat m_y1;
    stk::StkFloat m_y2;
    stk::StkFloat m_a0;
    stk::StkFloat m_b1;
    stk::StkFloat m_b2;


    stk::StkFloat Q;

    stk::StkFloat** nextSamplePerChannel;
};

}; //namespace instruments

#endif