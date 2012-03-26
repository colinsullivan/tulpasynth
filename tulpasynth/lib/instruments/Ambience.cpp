/**
 *  @file       Ambience.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#include <iostream>

#include "Ambience.hpp"

#include "AmbienceEnvelope.hpp"


using namespace instruments;

Ambience::Ambience() {
    ambienceInstr = new stk::BandedWG();
    e = new stk::Envelope();
    e->setTime(3);
    preset(0);
    freq(220.0);
}
Ambience::~Ambience() {
    delete e;
    delete ambienceInstr;
}

void Ambience::keyOn() {
    e->keyOn();
}
void Ambience::keyOff() {
    e->keyOff();
}

stk::StkFloat ambienceLoopTime = 0.0;
stk::StkFloat newAmbienceLoopTime;

stk::StkFrames& Ambience::next_buf(stk::StkFrames& frames) {
    stk::StkFloat envelopeTickValue, envelopeValue;
    
    if (this->playing()) {
        
        for (int i = 0; i < frames.frames(); i++) {
            envelopeTickValue = e->tick();
            envelopeValue = Ambience::CurvedEnvelopeLookup[(int)floor(envelopeTickValue*10000.0)];
            frames[i*NUM_CHANNELS+0] = frames[i*NUM_CHANNELS+1] = (stk::StkFloat)envelopeValue * (stk::StkFloat)ambienceInstr->tick();
        }
//        std::cout << "envelopeValue: " << envelopeValue << std::endl;
        
        if (e->getState() == 0.0 && envelopeValue == 0.0) {
            ambienceInstr->stopBowing(0.5);
        }
        
        newAmbienceLoopTime = ambienceLoopTime + frames.size();
        if (ambienceLoopTime == 0.0) {
//            std::cout << "preset 0 " << std::endl;
            preset(0);
            freq(329.63);
            keyOn();
            ambienceInstr->startBowing(1.0, 0.2);
        }
        else if (ambienceLoopTime < 4.0*stk::SRATE && newAmbienceLoopTime > 4.0*stk::SRATE && e->getState() == 0.0) {
//            std::cout << "keyOff" << std::endl;
            keyOff();
        }
        else if (ambienceLoopTime < 12.0*stk::SRATE && newAmbienceLoopTime > 12.0*stk::SRATE && e->getState() == 0.0) {
//            std::cout << "preset 01" << std::endl;
            preset(1);
            freq(493.88);
            keyOn();
            ambienceInstr->startBowing(1.0, 0.93);
        }
        else if (ambienceLoopTime < 20.0*stk::SRATE && newAmbienceLoopTime > 20.0*stk::SRATE && e->getState() == 0.0) {
//            std::cout << "keyOff" << std::endl;
            keyOff();
        }
        else if (ambienceLoopTime < 30.0*stk::SRATE && newAmbienceLoopTime > 30.0*stk::SRATE && e->getState() == 0.0) {
//            std::cout << "preset 02" << std::endl;
            preset(2);
            freq(440.0);
            keyOn();
            ambienceInstr->startBowing(1.0, 0.94);
        }
        else if (ambienceLoopTime < 36.0*stk::SRATE && newAmbienceLoopTime > 36.0*stk::SRATE && e->getState() == 0.0) {
//            std::cout << "keyOff" << std::endl;
            keyOff();
        }
        else if (ambienceLoopTime < 45.0*stk::SRATE && newAmbienceLoopTime > 45*stk::SRATE && e->getState() == 0.0) {
//            std::cout << "preset 03" << std::endl;
            preset(3);
            freq(587.33);
            keyOn();
            ambienceInstr->startBowing(1.0, 0.82);
        }
        else if (ambienceLoopTime < 50.0*stk::SRATE && newAmbienceLoopTime > 50.0*stk::SRATE && e->getState() == 0.0) {
//            std::cout << "keyOff" << std::endl;
            keyOff();
        }
        else if (ambienceLoopTime < 55.0*stk::SRATE && newAmbienceLoopTime > 55.0*stk::SRATE && e->getState() == 0.0) {
            newAmbienceLoopTime = 0.0;
        }
        ambienceLoopTime = newAmbienceLoopTime;
        
    }
    
    return frames;
}

void Ambience::preset(int aPreset) {
    if (aPreset == 0) {
        ambienceInstr->setPreset(3);
        // bow pressure
        ambienceInstr->controlChange(2, 0.2);
    }
    else if (aPreset == 1) {
        ambienceInstr->setPreset(1);
        // bow pressure
        ambienceInstr->controlChange(2, 0.3);
    }
    else if (aPreset == 2) {
        ambienceInstr->setPreset(3);
        // bow pressure
        ambienceInstr->controlChange(2, 0.64);
    }
    else if (aPreset == 3) {
        ambienceInstr->setPreset(2);
        // bow pressure
        ambienceInstr->controlChange(2, 0.25);
    }
}

void Ambience::freq(stk::StkFloat aFreq) {
    Instrument::freq(aFreq);
    ambienceInstr->setFrequency(_freq);
}