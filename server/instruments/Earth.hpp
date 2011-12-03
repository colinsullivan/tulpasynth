/**
 *  @file       Earth.hpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#ifndef _EARTH_HPP_
#define _EARTH_HPP_

#include "Instrument.hpp"
#include "RAMpler.hpp"

namespace instruments {
    class Earth : private RAMpler
    {
    public:
        Earth();
        ~Earth();
    };
};
#endif