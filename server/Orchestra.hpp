/**
 *  @file       Orchestra.hpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/


#ifndef _ORCHESTRA_HPP_
#define _ORCHESTRA_HPP_

#include <map>
#include <iostream>

#include "Globals.h"
// #include "instruments/Instrument.hpp"

namespace instruments {
    class Instrument;
}

/**
 *  @class  Encapsulation of current loop and instruments.
 **/
class Orchestra
{
public:
    Orchestra();
    ~Orchestra() {
        delete instrs;
    };

    /**
     *  Set the current time of the orchestra.
     *
     *  @param  aT  Time value [0.0 - 1.0]
     **/
    void set_t(double aT) {
        this->t = aT;
    };

    /**
     *  Get the current time of orchestra.
     **/
    double get_t() {
        return this->t;
    };

    /**
     *  Get current duration of the loop
     **/
    int get_duration() {
        return this->duration;
    };

    /**
     *  Add a new instrument to the orchestra
     **/
    void add_instrument(instruments::Instrument* anInstrument);

    /**
     *  Delete an instrument from the orchestra.
     **/
    void delete_instrument(int instrumentId);

    /**
     *  Retrieve an instrument given an id.
     *
     *  @param  instrumentId  The id of the instrument to retrieve.
     **/
    instruments::Instrument* get_instrument(int instrumentId);

    /**
     *  Generate a new ID for a newly created instrument.
     **/
    int generate_instrument_id() {
        return this->NEXT_INSTRUMENT_ID++;
    }

    /**
     *  Return the entire list of instruments for iteration.
     **/
    std::map<int, instruments::Instrument*>* get_instruments();

private:

    /**
     *  Duration of the loop (in samples)
     **/
    int duration;

    /**
     *  The current time relative to entire loop [0.0 - 1.0]
     **/
    double t;

    /**
     *  All instruments currently instantiated.  They are mapped 
     *  by their ids.
     **/
    std::map<int, instruments::Instrument*>* instrs;

    /**
     *  Static incrementing integer for ids of new 
     *  instruments
     **/
    int NEXT_INSTRUMENT_ID;

};

#endif