/**
 *  @file       Bubbly.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#include "Bubbly.hpp"

instruments::Bubbly::Bubbly(Orchestra* anOrch, Json::Value initialAttributes) : instruments::PitchedInstrument::PitchedInstrument(anOrch, initialAttributes) {
    this->nextSamplePerChannel = new stk::StkFloat*[CHANNELS];
    for(unsigned int i = 0; i < CHANNELS; i++) {
        this->nextSamplePerChannel[i] = new stk::StkFloat(0.0);
    }


    m_y1 = 0;
    m_y2 = 0;

    this->pitches[0] = 2093.0045;
    this->pitches[1] = 1661.2188;
    this->pitches[2] = 1318.5102;
    this->pitches[3] = 1046.5023;
    this->pitches[4] = 830.6094;
    this->pitches[5] = 659.2551;
    this->pitches[6] = 523.2511;
    this->pitches[7] = 415.3047;
    this->pitches[8] = 329.6276;
    this->pitches[9] = 261.6256;
    this->pitches[10] = 207.6523;
    this->pitches[11] = 164.8138;
    this->pitches[12] = 130.8128;
    this->pitches[13] = 103.8262;
    this->pitches[14] = 82.4069;
    this->pitches[15] = 65.4064;  
    this->pitches[16] = 51.9131;  
    this->pitches[17] = 41.2034;  
    this->pitches[18] = 32.7032;  
    this->pitches[19] = 25.9565;  
    this->pitches[20] = 20.6017;  
    this->pitches[21] = 16.3516;  
    this->pitches[22] = 12.9783;  
    this->pitches[23] = 10.3009;  
    this->pitches[24] = 8.1758;  
    this->pitches[25] = 6.4891;  
    this->pitches[26] = 5.1504;  
    this->pitches[27] = 4.0879;  
    this->pitches[28] = 3.2446;  
    this->pitches[29] = 2.5752;  
    this->pitches[30] = 2.0439;  
    this->pitches[31] = 1.6223;  

    this->set_attributes(initialAttributes);

    // Set low pass parameters
    // lpf.setCoefficients(0, next_b1, next_b2, next_a0, 0, true);
    // lpf.setResonance(440, 40, true);
    // lpf.setPole(0.8);

    this->finish_initializing();

};

void instruments::Bubbly::freq(stk::StkFloat aFreq) {
    /**
     *  Filter calculations stolen from ChucK: ugen_filter.cpp:757
     *  TODO: Encapsulate
     **/
    stk::StkFloat Q = 40;
    stk::StkFloat freq = aFreq;
    stk::StkFloat qres = std::max( .001, 1.0/Q );
    stk::StkFloat pfreq = freq * RADIANS_PER_SAMPLE;

    stk::StkFloat D = tan(pfreq * qres * 0.5);
    stk::StkFloat C = (1.0 - D) / (1.0 + D);
    stk::StkFloat cosfreq = cos(pfreq);
    stk::StkFloat next_b1 = (1.0 + C) * cosfreq;
    stk::StkFloat next_b2 = -C;
    stk::StkFloat next_a0 = (1.0 + C - next_b1) * 0.25;
    m_a0 = (SAMPLE)next_a0;
    m_b1 = (SAMPLE)next_b1;
    m_b2 = (SAMPLE)next_b2;

    if(freq > 9 ) {
        this->get_attributes()["gain"] = 1.5;
    }

    if(freq > 11) {
        this->get_attributes()["gain"] = 1.9;
    }

    // // m_freq = freq;
    // // m_Q = 1.0 / qres;
}

stk::StkFrames& instruments::Bubbly::next_buf(stk::StkFrames& frames, double nextBufferT) {

    // Next sample for this channel
    stk::StkFloat* nextSample = this->nextSamplePerChannel[0];

    // Fill buffer with result of impulse train
    for(unsigned int i = 0; i < frames.size(); i++) {
        frames[i] = (*nextSample);
    
        if((*nextSample) == 1.0) {
            (*nextSample) = 0.0;
        }

        /**
         *  Filter calculations stolen from ChucK: ugen_filter.cpp:777
         *  TODO: Encapsulate
         **/
        // go: adapated from SC3's RLPF
        SAMPLE y0 = m_a0 * frames[i] + m_b1 * m_y1 + m_b2 * m_y2;
        frames[i] = y0 + 2 * m_y1 + m_y2;
        m_y2 = m_y1;
        m_y1 = y0;


    }    


    // Copy into other channels
    // for(int channel = 1; channel < CHANNELS; channel++) {
    //     for(int i = 0; i < frames.size(); i++) {
    //         frames[i*CHANNELS+channel] = frames[i*CHANNELS];
    //     }
    // }
    return frames;
};