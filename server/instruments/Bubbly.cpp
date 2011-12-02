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

    // Initialize frequency calculations.
    this->freq(440);

    // Set low pass parameters
    // lpf.setCoefficients(0, next_b1, next_b2, next_a0, 0, true);
    // lpf.setResonance(440, 40, true);
    // lpf.setPole(0.8);

};

void instruments::Bubbly::freq(stk::StkFloat aFreq) {
    /**
     *  Filter calculations stolen from ChucK: ugen_filter.cpp:757
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