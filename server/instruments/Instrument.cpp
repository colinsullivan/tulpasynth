/**
 *  @file       Instrument.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#include "Instrument.hpp"

#include "../Orchestra.hpp"

instruments::Instrument::Instrument(Orchestra* anOrch) {
    this->orch = anOrch;

    this->id = this->orch->generate_instrument_id();

    this->orch->add_instrument(this);
};