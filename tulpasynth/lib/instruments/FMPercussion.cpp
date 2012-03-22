/**
 *  @file       FMPercussion.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#include "FMPercussion.hpp"
#include "Envelopes.hpp"

using namespace instruments;

FMPercussion::FMPercussion() {
    // Set initial frequencies
    this->carrierFrequency(440.0);
    this->modulatorFrequency(2000);    
    this->modulationIndex(2);
    
    this->_carrierEnvelope = new stk::Envelope();
    this->_modulatorEnvelope = new stk::Envelope();
    
    // Envelope duration
    this->_carrierEnvelope->setTime(0.25);
    this->_modulatorEnvelope->setTime(0.05);
    
    this->_modulatorPhase = 0.0;
    this->_carrierPhase = 0.0;
    
    this->stop();
}

FMPercussion::~FMPercussion() {
    
}

stk::StkFrames& FMPercussion::next_buf(stk::StkFrames& frames) {
    // Value we will be multiplying to the base carrier frequency
    stk::StkFloat modulationValue;
    
    stk::StkFloat carrierEnvelopeValue;
    stk::StkFloat modulatorEnvelopeValue;
    
    
//    
    
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
            
            // Carrier wave is also a sine wave, with a frequency modulated by above
            _carrierPhase += (this->_carrierFrequency + this->_carrierFrequency*modulationValue)/stk::SRATE;
            if(_carrierPhase > 1.0f) {
                _carrierPhase -= 1.0f;
            }
            
            // Carrier envelope value from lookup table
            carrierEnvelopeValue = FMPercussion::CarrierAttackEnvelopeLookup[(int)floor(this->_carrierEnvelope->tick()*10000.0)];
            
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
        


//    for(int i = 0; i < frames.frames(); i++) {
//        // Modulator wave is a sine wave
//        this->_modulatorPhase += this->_modulatorFrequency/stk::SRATE;
//        if(this->_modulatorPhase > 1.0f) {
//            this->_modulatorPhase -= 1.0f;
//        }
//        // Modulation value will oscillate between [-0.5, 0.5] if index is 0.5,
//        // [-0.33, 0.33] if index is 0.33, etc
//        modulationValue = this->_modulationIndex*(stk::StkFloat)sin(stk::TWO_PI*this->_modulatorPhase);
//        
//        // Carrier wave is also a sine wave, with a frequency modulated by above
//        this->_carrierPhase += (this->_carrierFrequency + this->_carrierFrequency*modulationValue)/stk::SRATE;
//        if(this->_carrierPhase > 1.0f) {
//            this->_carrierPhase -= 1.0f;
//        }
//        
//        // Resulting sample is output of carrier wave
//        frames[i*NUM_CHANNELS+0] = frames[i*NUM_CHANNELS+1] = this->_carrierEnvelope.tick()*(stk::StkFloat)sin(stk::TWO_PI * this->_carrierPhase);
//    }
//    return frames;
}

void FMPercussion::carrierFrequency(stk::StkFloat aFrequency) {
    this->_carrierFrequency = aFrequency;
}
void FMPercussion::modulatorFrequency(stk::StkFloat aFrequency) {
    this->_modulatorFrequency = aFrequency;
}
stk::StkFloat FMPercussion::carrierFrequency() {
    return this->_carrierFrequency;
}
stk::StkFloat FMPercussion::modulatorFrequency() {
    return this->_modulatorFrequency;
}
void FMPercussion::modulationIndex(stk::StkFloat aModIndex) {
    this->_modulationIndex = aModIndex;
}
stk::StkFloat FMPercussion::modulationIndex() {
    return this->_modulationIndex;
}

void FMPercussion::freq(stk::StkFloat aFreq) {
    this->carrierFrequency(aFreq);
}

void FMPercussion::play() {
    Instrument::play();
 
    this->_modulatorEnvelope->setValue(0.0);
    this->_modulatorEnvelope->keyOn();
    this->_carrierEnvelope->setValue(0.0);
    this->_carrierEnvelope->keyOn();
    this->_modulatorPhase = 0.0;
}

void FMPercussion::velocity(stk::StkFloat aVelocity) {
    if (aVelocity > 0.9) {
        aVelocity = 0.9;
    }

    Instrument::velocity(aVelocity);

    this->modulationIndex((this->_velocity * 30));
}

void FMPercussion::stop() {
    Instrument::stop();
    
    this->_carrierEnvelope->setValue(1.0);
    this->_modulatorEnvelope->setValue(1.0);
}