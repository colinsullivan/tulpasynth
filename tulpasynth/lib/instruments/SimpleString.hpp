/**
 *  @file       SimpleString.hpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#ifndef _SIMPLESTRING_H_
#define _SIMPLESTRING_H_

#include "StifKarp.h"

#include "Instrument.hpp"

namespace instruments {

    /**
     *  @class      Basic plucked string instrument.  Delegating to 
     *  stk::StifKarp for most of the functionality.
     *  @extends    instruments::Instrument
     **/
    class SimpleString : protected Instrument
    {
    public:
        SimpleString();
        ~SimpleString();

        /**
         *  Called when the string should be plucked.
         **/
        virtual void play();

        /**
         *  Render audio samples.
         **/
        virtual stk::StkFloat next_samp(int channel);
        virtual stk::StkFrames& next_buf(stk::StkFrames& frames, double nextBufferT);
        
        /**
         *  Set frequency of next pluck.
         *
         *  @param  aFreq -   Frequency to use.
         **/
        void freq(float aFreq);

    protected:
        /**
         *  StifKarp instance used for rendering.
         **/
        stk::StifKarp* _karp;

        /**
         *  How many frames we've been playing a note for.
         **/
        stk::StkFloat _playingFor;

        /**
         *  Duration of a note
         **/
        stk::StkFloat _noteDuration;
    };
    
}

#endif