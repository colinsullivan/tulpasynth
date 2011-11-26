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
#include <Stk.h>

#include <json/value.h>
#include <iostream>

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
            return this->attributes;
        };

        void set_attributes(Json::Value newAttributes) {
            this->attributes = newAttributes;
        };

        /**
         *  Start playing this instrument
         **/
        virtual void play() {
            // Should be overridden by subclasses
            return;
        };

        /**
         *  Pull the next sample from this unit generator
         *
         *  @param  chan  Channel of sample to retrieve
         **/
        virtual stk::StkFloat next_samp(int chan) {
            // Should be overridden in subclasses
            return 0.0;
        };

        /**
         *  Fill a channel of the StkFrames object with 
         *  computed outputs.  Returns same reference 
         *  to StkFrames object passed in.
         *
         *  @param  frames  The frames to fill with audio
         *  @param  channel  ?
         **/
        virtual stk::StkFrames& next_buf(stk::StkFrames& frames, unsigned int channel) {
            return frames;
        };
    protected:
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