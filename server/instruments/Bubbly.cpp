/**
 *  @file       Bubbly.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#include "Bubbly.hpp"

instruments::Bubbly::Bubbly(Orchestra* anOrch, Json::Value initialAttributes) : instruments::Instrument::Instrument(anOrch, initialAttributes) {
    this->nextSamplePerChannel = new stk::StkFloat*[CHANNELS];
    for(unsigned int i = 0; i < CHANNELS; i++) {
        this->nextSamplePerChannel[i] = new stk::StkFloat(0.0);
    }


    m_y1 = 0;
    m_y2 = 0;

    // Bubbly object should be sent a `pitchIndex` attribute.
    int pitchIndex = initialAttributes["pitchIndex"].asInt();

    float descendingMajorThirds[32] = {  
        2093.004522, 
        1661.218790, 
        1318.510228, 
        1046.502261, 
        830.609395, 
        659.255114, 
        523.251131, 
        415.304698, 
        329.627557, 
        261.625565, 
        207.652349, 
        164.813778, 
        130.812783, 
        103.826174, 
        82.406889, 
        65.406391, 
        51.913087, 
        41.203445, 
        32.703196, 
        25.956544, 
        20.601722, 
        16.351598, 
        12.978272, 
        10.300861, 
        8.175799, 
        6.489136, 
        5.150431, 
        4.087899, 
        3.244568, 
        2.575215, 
        2.043950, 
        1.622284 
    };


    // float frequency = 110*(32 - (pitchIndex));
    float frequency = descendingMajorThirds[pitchIndex];

    std::cout << "frequency:\n" << frequency << std::endl;

    // Convert to frequency
    this->freq(frequency);

    // Set low pass parameters
    // lpf.setCoefficients(0, next_b1, next_b2, next_a0, 0, true);
    // lpf.setResonance(440, 40, true);
    // lpf.setPole(0.8);

};

void instruments::Bubbly::freq(stk::StkFloat aFreq) {
    /**
     *  Filter calculations stolen from ChucK: ugen_filter.cpp:757
     *  TODO: Figure out GPL issues
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

    // // m_freq = freq;
    // // m_Q = 1.0 / qres;
}

stk::StkFrames& instruments::Bubbly::next_buf(stk::StkFrames& frames, unsigned int channel) {

    // Next sample for this channel
    stk::StkFloat* nextSample = this->nextSamplePerChannel[channel];

    // Fill buffer with result of impulse train
    for(unsigned int i = 0; i < frames.size(); i++) {
        frames[i] = (*nextSample);
        if((*nextSample) == 1.0) {
            (*nextSample) = 0.0;
        }

        /**
         *  Filter calculations stolen from ChucK: ugen_filter.cpp:777
         *  TODO: Deal with GPL issues
         **/
        // go: adapated from SC3's RLPF
        SAMPLE y0 = m_a0 * frames[i] + m_b1 * m_y1 + m_b2 * m_y2;
        frames[i] = y0 + 2 * m_y1 + m_y2;
        m_y2 = m_y1;
        m_y1 = y0;


    }

    // Filter result.
    // lpf.tick(frames, channel);

    return frames;
};