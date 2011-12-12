/**
 *  @file       OrganBell.hpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#ifndef _ORGANBELL_HPP_
#define _ORGANBELL_HPP_

#include <Math.h> // pow

#include <Stk.h>
#include <SineWave.h>

#include "PitchedInstrument.hpp"

namespace instruments {
    class OrganBell : private PitchedInstrument
    {
    public:
        OrganBell(Orchestra* anOrch, Json::Value initialAttributes);
        ~OrganBell(){};

        /**
         *  Set the frequency of each partial relative
         *  to its index in the `partials` array.
         **/
        virtual void freq(stk::StkFloat aFreq);

        virtual stk::StkFrames& next_buf(stk::StkFrames& frames, double nextBufferT);

        virtual void play() {
            PitchedInstrument::play();

            // Reset phase of modulator
            modulator.addPhase(1-modulator.lastOut());

            // Reset attack and release
            mAttack = 0;
            mRelease = 1;


        }


    private:

        /**
         *  Partials for sound
         **/
        stk::SineWave partials[8];

        /**
         *  Gain for each partial
         **/
        stk::StkFloat partialGain[8];

        /**
         *  Current frequency of each partial
         **/
        stk::StkFloat partialFreq[8];

        /**
         *  FM
         **/
        stk::SineWave modulator;

        /**
         *  Manual envelope, attack and release indicies for 
         *  the current note.  On `play`, the attack index will
         *  be set to 0, and the release to 1.
         **/
        stk::StkFloat mAttack;
        stk::StkFloat mRelease;

    };

};

#endif