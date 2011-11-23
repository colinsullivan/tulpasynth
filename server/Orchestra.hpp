/**
 *  @file       Orchestra.hpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/


#ifndef _ORCHESTRA_HPP_
#define _ORCHESTRA_HPP_

#include <vector>
#include <Instrmnt.h>

#include "Globals.h"

/**
 *  @class  Encapsulation of current loop and instruments.
 **/
class Orchestra
{
public:
    Orchestra() {
        this->t = 0.0;
        this->duration = 4*SAMPLE_RATE;
        this->instruments = new std::vector<stk::Instrmnt*>();
    };
    ~Orchestra() {
        delete instruments;
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
     *  All instruments currently instantiated
     **/
    std::vector<stk::Instrmnt*>* instruments;



};

#endif