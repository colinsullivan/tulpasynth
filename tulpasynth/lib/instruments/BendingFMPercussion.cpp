/**
 *  @file       BendingFMPercussion.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#include <iostream>

#include "BendingFMPercussion.hpp"

using namespace instruments;

BendingFMPercussion::BendingFMPercussion() {
    this->modulatorFrequency(1500);
    this->bendDirection(1.0);
}
BendingFMPercussion::~BendingFMPercussion() {
    
}


void BendingFMPercussion::velocity(stk::StkFloat aVelocity) {
    Instrument::velocity(aVelocity);
    
    this->modulationIndex((this->_velocity * 35));

}

void BendingFMPercussion::freq(stk::StkFloat aFreq) {
    FMPercussion::freq(aFreq);
    
    
}

void BendingFMPercussion::play() {
    FMPercussion::play();
    
}
void BendingFMPercussion::stop() {
    FMPercussion::stop();
}

void BendingFMPercussion::duration(stk::StkFloat aDuration) {
    
    _duration = aDuration;
    _carrierEnvelope->setTime(aDuration);
    
}

void BendingFMPercussion::bendDirection(stk::StkFloat aDirection) {
    _bendDirection = aDirection;    
}

stk::StkFrames& BendingFMPercussion::next_buf(stk::StkFrames& frames) {
    // Value we will be multiplying to the base carrier frequency
    stk::StkFloat modulationValue;
    
    stk::StkFloat carrierEnvelopeTickValue;
    stk::StkFloat carrierEnvelopeValue;
    stk::StkFloat modulatorEnvelopeValue;
    
    if (this->mPlaying) {
        for(int i = 0; i < frames.frames(); i++) {
            // Modulator wave is a sine wave
            this->_modulatorPhase += this->_modulatorFrequency/stk::SRATE;
            if(this->_modulatorPhase > 1.0f) {
                this->_modulatorPhase -= 1.0f;
            }
            // Modulation value will oscillate between [-0.5, 0.5] if index is 0.5,
            // [-0.33, 0.33] if index is 0.33, etc
            modulationValue = this->_modulationIndex*TrigLookupTables::SIN_LOOKUP[(int)floor(this->_modulatorPhase*10000.0)];
            
            modulatorEnvelopeValue = FMPercussion::ModulatorAttackEnvelopeLookup[(int)floor(this->_modulatorEnvelope->tick()*10000.0)];
            
            modulationValue *= modulatorEnvelopeValue;
            
            // Carrier envelope value from lookup table
            carrierEnvelopeTickValue = this->_carrierEnvelope->tick();
            carrierEnvelopeValue = FMPercussion::CarrierAttackEnvelopeLookup[(int)floor(carrierEnvelopeTickValue*10000.0)];

            // Carrier wave is also a sine wave, with a frequency modulated by above
            _carrierPhase += (
                              this->_carrierFrequency
                              +
                              this->_carrierFrequency*modulationValue
                              +
                              (_bendDirection * 220 * carrierEnvelopeTickValue)
                            )/stk::SRATE;
            if(_carrierPhase > 1.0f) {
                _carrierPhase -= 1.0f;
            }
            
            
            // Resulting sample is output of carrier wave
            //        frames[i*NUM_CHANNELS+0] = frames[i*NUM_CHANNELS+1] = carrierEnvelopeValue*(stk::StkFloat)SIN_LOOKUP[(int)floor(this->_carrierPhase * 10000.0)];
            frames[i*NUM_CHANNELS+0] = frames[i*NUM_CHANNELS+1] = carrierEnvelopeValue*TrigLookupTables::SIN_LOOKUP[(int)floor(this->_carrierPhase*10000.0)];
            
            // if we're done
            if (this->_carrierEnvelope->getState() == 0.0) {
                this->stop();
            }
        }
    }
    
    return frames;
    

}