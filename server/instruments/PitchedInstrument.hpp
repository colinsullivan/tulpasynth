/**
 *  @file       PitchedInstrument.hpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/


#ifndef _PITCHEDINSTRUMENT_HPP_
#define _PITCHEDINSTRUMENT_HPP_

#include "Instrument.hpp"

namespace instruments {
    
    /**
     *  @class  Base class for any instruments that have a pitch.
     **/
    class PitchedInstrument : protected Instrument
    {
    public:
        PitchedInstrument(Orchestra* anOrch, Json::Value initialAttributes);
        ~PitchedInstrument() {};

        /**
         *  Set the pitch of this instrument in Hz.
         **/
        virtual void freq(stk::StkFloat aFreq);

        /**
         *  Override so we can handle changing of pitch index.
         **/
        virtual void set_attributes(Json::Value newAttributes);

        virtual Json::Value get_attributes() {
            return Instrument::get_attributes();
        }

        virtual void finish_initializing() {
            Instrument::finish_initializing();
        }

        virtual void play() {
            Instrument::play();
        }


    protected:
        /**
         *  Array of pitches to use when assigning the pitch
         *  based on pitch index.
         **/
        float pitches[32];
    };

};

#endif