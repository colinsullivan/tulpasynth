/**
 *  @file       OrganBell.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#include "OrganBell.hpp"

instruments::OrganBell::OrganBell(Orchestra* anOrch, Json::Value initialAttributes) : instruments::PitchedInstrument::PitchedInstrument(anOrch, initialAttributes) {
    // Set gain for each partial (lowest frequency is index 0)
    partialGain[0] = 1.0;
    partialGain[1] = 0.8;
    partialGain[2] = 0.5;
    partialGain[3] = 1/3;
    partialGain[4] = 0.25;
    partialGain[5] = 0.2;
    partialGain[6] = 2/3;
    partialGain[7] = 0.142;


    this->pitches[0] = 3520.0000;
    this->pitches[1] = 2959.9554;
    this->pitches[2] = 2489.0159;
    this->pitches[3] = 2093.0045;
    this->pitches[4] = 1760.0000;
    this->pitches[5] = 1479.9777;
    this->pitches[6] = 1244.5079;
    this->pitches[7] = 1046.5023;
    this->pitches[8] = 880.0000;
    this->pitches[9] = 739.9888;
    this->pitches[10] = 622.2540;
    this->pitches[11] = 523.2511;
    this->pitches[12] = 440.0000;
    this->pitches[13] = 369.9944;
    this->pitches[14] = 311.1270;
    this->pitches[15] = 261.6256;
    this->pitches[16] = 220.0000;
    this->pitches[17] = 184.9972;
    this->pitches[18] = 155.5635;
    this->pitches[19] = 130.8128;
    this->pitches[20] = 110.0000;
    this->pitches[21] = 92.4986;
    this->pitches[22] = 77.7817;
    this->pitches[23] = 65.4064;
    this->pitches[24] = 55.0000;
    this->pitches[25] = 46.2493;
    this->pitches[26] = 38.8909;
    this->pitches[27] = 32.7032;
    this->pitches[28] = 27.5000;
    this->pitches[29] = 23.1247;
    this->pitches[30] = 19.4454;
    this->pitches[31] = 16.3516;

    // Frequency of FM in Hz
    modulator.setFrequency(10);

    this->finish_initializing();
}

void instruments::OrganBell::freq(stk::StkFloat aFreq) {
    for(int i = 0; i < 8; i++) {

        partialFreq[i] = aFreq * pow(2, i);
        partials[i].setFrequency(partialFreq[i]);
    }
}

stk::StkFrames& instruments::OrganBell::next_buf(stk::StkFrames& frames, double nextBufferT) {

    stk::StkFloat freqModulateValue;
    stk::StkFloat envelopeValue;

    if(this->mPlaying) {
        // For each frame
        for(int i = 0; i < frames.size(); i++) {

            // Grab value from modulator to modulate frequency
            freqModulateValue = 0.0025*modulator.tick()+1.0;

            // Determine envelope value
            if(mAttack < 1.0) {
                // We're still on attack
                mAttack += 0.002;
                envelopeValue = pow(mAttack, 3.0);
            }
            else if(mAttack >= 1.0 && mRelease > 0.0) {
                // We're decaying
                mRelease -= 0.000009;
                envelopeValue = -1.0 * (sqrt(1.0 - pow(mRelease, 4.0)) - 1.0);
            }
            else if(mAttack >= 1.0 && mRelease <= 0.0) {
                // We're done playing this note.
                this->mPlaying = false;
                envelopeValue = 0;
            }

            // For each partial
            for(int j = 0; j < 8; j++) {
                // Modulate frequency
                partials[j].setFrequency(freqModulateValue*partialFreq[j]);
                // Output partial sample
                frames[i] += partials[j].tick()*partialGain[j]*envelopeValue;
            }
        }        
    }


    return frames;
}