/**
 *  @file       Instrument.hpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/


#ifndef _INSTRUMENT_HPP_
#define _INSTRUMENT_HPP_

// #include "../Orchestra.hpp"
#include <Stk.h>
//#include <json/value.h>
#include <iostream>
#include <string>

#include "Globals.h"

// class Orchestra;

namespace instruments {

    /**
     *  @class  Base class for all instruments.  Most of this is commented
     *  because it was from tulpasynth v0.1.
     **/
    class Instrument
    {
    public:
        Instrument();
        /**
         *  Instrument constructor
         *
         *  @param  anOrch  `Orchestra` instance to add
         *  ourselves to.
         *  @param  initialAttributes  The initial attributes for this instrument.
         **/
//        Instrument(/*Orchestra* anOrch, Json::Value initialAttributes*/);
        ~Instrument(){};

        /**
         *  Should be called when instrument is finished initializing,
         *  and is ready to be played.
         **/
//        virtual void finish_initializing();

//        int get_id() {
//            return this->attributes["id"].asInt();
//        };
//
//        stk::StkFloat get_gain() {
//            return (stk::StkFloat)this->attributes["gain"].asDouble();
//        }
//
//        virtual Json::Value get_attributes() {
//            return this->attributes;
//        };
//
//        virtual void set_attributes(Json::Value newAttributes) {
//            // Default gain value
//            // double gain = newAttributes.get("gain", this->defaultAttributes["gain"].asDouble()).asDouble();
//            // newAttributes["gain"] = gain;
//
//            this->attributes = newAttributes;
//        };
//
        /**
         *  Start playing this instrument
         **/
        virtual void play() {
            this->mPlaying = true;
            return;
        };
        virtual void stop() {
            this->mPlaying = false;
            return;
        };
        
        
        virtual void velocity(stk::StkFloat aVelocity) {
            this->_velocity = aVelocity;
        }
        
        virtual void freq(stk::StkFloat aFreq) {
            this->_freq = aFreq;
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
         *
         *  @param  nextBufferT  The t value the orchestra will have at
         *  the next buffer.
         **/
        virtual stk::StkFrames& next_buf(stk::StkFrames& frames/*, double nextBufferT*/) {
            // Should be overridden in subclasses
            std::cerr << "WARNING: instruments::Instrument::next_buf is a passthrough." << std::endl;
            return frames;
        };

//        void set_ns(std::string aNamespace) {
//            this->ns = aNamespace;
//        }
//        std::string get_ns() {
//            return this->ns;
//        }
        
        static std::vector<Instrument*>* Instances;
    protected:
        /**
         *  The attributes of this object (including id)
         **/
//        Json::Value attributes;

        /**
         *  Any default attributes
         **/
//        Json::Value defaultAttributes;

        /**
         *  Reference to the orchestra
         **/
//        Orchestra* orch;

        /**
         *  If this instrument is currently playing.
         **/
        bool mPlaying;
        
        stk::StkFloat _velocity;
        stk::StkFloat _freq;

        /**
         *  Save namespace
         **/
//        std::string ns;

    private:

    };

}
#endif