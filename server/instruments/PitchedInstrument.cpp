/**
 *  @file       PitchedInstrument.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#include "PitchedInstrument.hpp"

instruments::PitchedInstrument::PitchedInstrument(Orchestra* anOrch, Json::Value initialAttributes) : instruments::Instrument::Instrument(anOrch, initialAttributes) {
    for(int i = 0; i < 32; i++) {
        this->pitches[i] = -1;
    }
}

void instruments::PitchedInstrument::set_attributes(Json::Value newAttributes) {
    instruments::Instrument::set_attributes(newAttributes);

    this->freq(this->pitches[newAttributes["pitchIndex"].asInt()]);
}

void instruments::PitchedInstrument::freq(stk::StkFloat aFreq) {
    // Subclasses should override
}