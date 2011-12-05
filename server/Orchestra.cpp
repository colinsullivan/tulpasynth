/**
 *  @file       Orchestra.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#include "Orchestra.hpp"
#include "instruments/Instrument.hpp"

Orchestra::Orchestra()  {
    this->t = 0.0;
    this->duration = 4*SAMPLE_RATE;
    this->instrs = new std::map<int, instruments::Instrument*>();

    /**
     *  ID of new instruments
     **/
    this->NEXT_INSTRUMENT_ID = 1;
}