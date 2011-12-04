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

        stk::StkFloat get_gain() {
            return (stk::StkFloat)this->attributes["gain"].asDouble();
        }

        virtual Json::Value get_attributes() {
            return this->attributes;
        };

        void set_attributes(Json::Value newAttributes) {
            // Default gain value
            double gain = newAttributes.get("gain", this->defaultAttributes["gain"].asDouble()).asDouble();
            newAttributes["gain"] = gain;

            this->attributes = newAttributes;
        };

        /**
         *  Start playing this instrument
         **/
        virtual void play() {
            // Should be overridden by subclasses
            std::cerr << "WARNING: instruments::Instrument::play does nothing." << std::endl;
            return;
        };

        /**
         *  Pull the next sample from this unit generator
         *
         *  @param  chan  Channel of sample to retrieve
         **/
        virtual stk::StkFloat next_samp(int channel) {
            // Should be overridden in subclasses
            std::cerr << "WARNING: instruments::Instrument::next_samp returns zeros." << std::endl;
            return 0.0;
        };

        /**
         *  Fill a channel of the StkFrames object with 
         *  computed outputs.  Returns same reference 
         *  to StkFrames object passed in.
         *
         *  @param  frames  The frames to fill with audio.  Should have the
         *  same number of channels as `CHANNELS`.
         **/
        virtual stk::StkFrames& next_buf(stk::StkFrames& frames) {
            // Should be overridden in subclasses
            std::cerr << "WARNING: instruments::Instrument::next_buf is a passthrough." << std::endl;
            return frames;
        };
    protected:
        /**
         *  The attributes of this object (including id)
         **/
        Json::Value attributes;

        /**
         *  Any default attributes
         **/
        Json::Value defaultAttributes;

        /**
         *  Reference to the orchestra
         **/
        Orchestra* orch;
    private:
        
    };

}
#endif