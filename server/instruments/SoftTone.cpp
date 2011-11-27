/**
 *  @file       SoftTone.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#include "SoftTone.hpp"

instruments::SoftTone::SoftTone(Orchestra* anOrch, Json::Value initialAttributes, stk::StkFloat lowestFrequency) : instruments::Instrument::Instrument(anOrch, initialAttributes), stk::BlowHole(lowestFrequency) {
        
};