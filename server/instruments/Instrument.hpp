/**
 *  @file       Instrument.hpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/


#ifndef _INSTRUMENT_HPP_
#define _INSTRUMENT_HPP_

// #include "../Orchestra.hpp"

#include <json/value.h>

class Orchestra;

namespace instruments {

    /**
     *  @class  Base class for all instruments.
     **/
    class Instrument
    {
    public:
        Instrument(){};
        /**
         *  Instrument constructor
         *
         *  @param  anOrch  `Orchestra` instance to add
         *  ourselves to.
         **/
        Instrument(Orchestra* anOrch);
        ~Instrument(){};

        int get_id() {
            return this->id;
        };

        virtual Json::Value get_attributes_object() {
            Json::Value result;
            result["id"] = this->id;
            return result;
        };
    private:

        /**
         *  The id of this instrument
         **/
        int id;

        /**
         *  Reference to the orchestra
         **/
        Orchestra* orch;
    };

}
#endif