/**
 *  @file       FMPercussion.hpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#ifndef _FMPERCUSSION_H_
#define _FMPERCUSSION_H_

#include "Envelope.h"

#include "Instrument.hpp"

namespace instruments {

    class FMPercussion : public Instrument
    {
    public:
        FMPercussion();
        ~FMPercussion();
        
        virtual stk::StkFrames& next_buf(stk::StkFrames& frames);

        /**
         *  Modify carrier/modulator frequencies
         **/
        void carrierFrequency(stk::StkFloat aFrequency);
        void modulatorFrequency(stk::StkFloat aFrequency);
        stk::StkFloat carrierFrequency();
        stk::StkFloat modulatorFrequency();

        /**
         *  Modify modulation index
         **/
        void modulationIndex(stk::StkFloat aModIndex);
        stk::StkFloat modulationIndex();
        
        virtual void play();
        virtual void stop();

        virtual void velocity(stk::StkFloat aVelocity);

        virtual void freq(stk::StkFloat aFreq);

    private:
        /**
         *  Frequencies of both carrier and modulator waves
         **/
        stk::StkFloat _carrierFrequency;
        stk::StkFloat _modulatorFrequency;
        
        /**
         *  Amount to modulate carrier frequency.  A value of
         *  0.5 means the carrier frequency will modulate 
         *  50% to 150%.
         **/
        stk::StkFloat _modulationIndex;
        
        /**
         *  Envelope to use for turning on and off
         **/
        stk::Envelope* _carrierEnvelope;
        stk::Envelope* _modulatorEnvelope;
        
        /**
         *  Phase and state used for rendering.
         **/
        // Instantaneous phase of both carrier and modulator waves
        stk::StkFloat _modulatorPhase;
        stk::StkFloat _carrierPhase;
        
        /**
         *  This attack curve was generated with the `CurveTable`
         *  ChucK object.
         *
         *  See curve:
         *  https://docs.google.com/spreadsheet/ccc?key=0AluQWmnCzsgidG9faThlUUJFdXFYSVJfZXE0S0NBbVE
         **/
        static stk::StkFloat CarrierAttackEnvelopeLookup[10001];
        
        /**
         *  This attack curve was also generated with the `CurveTable` 
         *  ChucK object.
         *
         *  See curve:
         *  https://docs.google.com/spreadsheet/ccc?key=0AluQWmnCzsgidHpFY2J1Y3FPZXhrSUhyRUdtYWNKbXc
         **/
        static stk::StkFloat ModulatorAttackEnvelopeLookup[10001];
    };    
}


#endif