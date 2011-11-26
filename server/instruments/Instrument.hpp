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
         *  @param  initialAttributes  The initial attributes for this instrument.
         **/
        Instrument(Orchestra* anOrch, Json::Value initialAttributes);
        ~Instrument(){};

        int get_id() {
            return this->attributes["id"].asInt();
        };

        virtual Json::Value get_attributes() {
            return attributes;
        };

        void set_attributes(Json::Value newAttributes) {
            this->attributes = newAttributes;
        }
    protected:

        /**
         *  The id of this instrument
         **/
        int id;

        /**
         *  The attributes of this object (including id)
         **/
        Json::Value attributes;

        /**
         *  Reference to the orchestra
         **/
        Orchestra* orch;
    };

}
#endif