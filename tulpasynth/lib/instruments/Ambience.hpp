/**
 *  @file       Ambience.hpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#ifndef tulpasynth_Ambience_h
#define tulpasynth_Ambience_h

#include "Instrument.hpp"

#include "BandedWG.h"
#include "Envelope.h"

namespace instruments {

    class Ambience : protected Instrument {
    public:
        
        Ambience();
        ~Ambience();
        
        virtual stk::StkFrames& next_buf(stk::StkFrames& frames);
        
        /**
         *  Our own preset numbers.
         **/
        void preset(int aPreset);
        
        void keyOn();
        void keyOff();
        
        virtual void freq(stk::StkFloat aFreq);
    protected:
        stk::BandedWG* ambienceInstr;
        stk::Envelope* e;
        
        static stk::StkFloat CurvedEnvelopeLookup[10001];
        
    };
}
#endif
