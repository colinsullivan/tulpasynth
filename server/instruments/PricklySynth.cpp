/**
 *  @file       PricklySynth.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#include "PricklySynth.hpp"


instruments::PricklySynth::PricklySynth(Orchestra* anOrch, Json::Value initialAttributes) : instruments::Instrument::Instrument(anOrch, initialAttributes) {

    float descendingMinorThirds[32] = {
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        440.000000, 
        369.994423, 
        311.126984, 
        261.625565, 
        220.000000, 
        184.997211, 
        155.563492, 
        130.812783, 
        110.000000, 
        92.498606, 
        77.781746, 
        65.406391, 
        55.000000, 
        46.249303, 
        38.890873
    };

    stk::StkFloat freq = descendingMinorThirds[initialAttributes["pitchIndex"].asInt()];



    this->mMinFilterFreq = 110;
    this->mMaxFilterFreq = 2000;


    // BPF f;
    this->mFundSawGain = 1.0;
    this->mFundSaw.setFrequency(freq);
    this->mFundSaw.setHarmonics(10);

    this->mFundSineGain = 0.9;
    this->mFundSine.setFrequency(freq);

    this->mLowSineGain = 0.1;
    this->mLowSine.setFrequency(freq/4);

    this->mJuiceGain = 1;
    this->mJuice.setFrequency(55);

    this->mSweeper.setFrequency(0.15);
    this->mSweeperGain = 1;

    // Note on in 1/10 of a second
    this->mEnvelope.setTime(0.10);

    this->m_y1 = 0;
    this->m_y2 = 0;

    this->filterFreq(this->mMinFilterFreq);

    this->attributes["gain"] = 0.40;

    this->mPlayedFrames = 0;

    this->finish_initializing();
};

// void instruments::PricklySynth::set_attributes(Json::Value newAttributes) {

//     // Calculate duration from start and end times
//     float dur = newAttributes["endTime"] - newAttributes["startTime"];

//     bool durationHasChanged = false;

//     instruments::Instrument::set_attributes(newAttributes);



// }

void instruments::PricklySynth::play() {
    Instrument::play();

    // Restart filter
    // this->mSweeper.addPhase(1-this->mSweeper.lastOut());

    // Set filter to oscillate once during entire note
    // float durationSeconds = (
    //     (this->attributes["endTime"].asFloat() - this->attributes["startTime"].asFloat())
    //     *(float)this->orch->get_duration()
    // )/(float)SAMPLE_RATE;
    // this->mSweeper.setFrequency(durationSeconds);

    this->mEnvelope.keyOn();
    this->mPlayedFrames = 0;
    this->mKeyedOff = false;
};


stk::StkFrames& instruments::PricklySynth::next_buf(stk::StkFrames& frames, double nextBufferT) {
    int durationSamples = floor(
        (this->attributes["endTime"].asFloat() - this->attributes["startTime"].asFloat())
        *(float)this->orch->get_duration()
    );

    // Sample (relative to loop duration) on which this synth should start
    double startFrame = this->attributes["startTime"].asFloat()*(double)this->orch->get_duration();

    // Sample (relative to loop duration) on which this synth should end
    double endFrame = this->attributes["endTime"].asFloat()*(double)this->orch->get_duration();

    // Current frame at the beginning of this buffer
    double currentBufferFrame = this->orch->get_t()*(double)this->orch->get_duration();
    double nextBufferFrame = nextBufferT*(double)this->orch->get_duration();



    if(this->mPlaying == true) {
        
        int totalFrames = ceil(endFrame - startFrame);

        // Fill buffer
        for(unsigned int i = 0; i < frames.size(); i++) {
            frames[i] += this->mFundSineGain*this->mFundSine.tick();
            frames[i] += this->mFundSawGain*this->mFundSaw.tick();
            frames[i] += this->mLowSineGain*this->mLowSine.tick();
            frames[i] += this->mJuiceGain*this->mJuice.tick();

            /**
             *  Continue sweeping filter
             **/
            this->filterFreq(
                (this->mMaxFilterFreq-this->mMinFilterFreq)
                *
                (0.5*(this->mSweeper.tick()+1))
                +this->mMinFilterFreq
            );

            /**
             *  BPF code stolen from ChucK ugen_filter.cpp:701
             **/
            stk::StkFloat y0;
            
            // go: adapted from SC3's LPF
            y0 = frames[i] + this->m_b1 * this->m_y1 + this->m_b2 * this->m_y2;
            frames[i] = this->m_a0 * (y0 - this->m_y2);
            this->m_y2 = this->m_y1;
            this->m_y1 = y0;

            // Envelope sound
            frames[i] *= this->mEnvelope.tick();

            this->mPlayedFrames++;

            int framesRemaining = totalFrames - this->mPlayedFrames;
            // std::cout << "framesRemaining:\n" << framesRemaining << std::endl;


            // If there's only 0.1 seconds left, need to turn off envelope
            if(
                
                // If we haven't already keyed off
                !this->mKeyedOff
                &&
                (
                    // And there is 0.1 seconds remaining
                    endFrame - currentBufferFrame == 0.1*SAMPLE_RATE
                    ||
                    // or there is more than 0.1 seconds remaining
                    (
                        endFrame - currentBufferFrame > 0.1*SAMPLE_RATE
                        &&
                        // And next time there will be less than 0.1 seconds remaining
                        endFrame - nextBufferFrame < 0.1*SAMPLE_RATE
                    )
                )

            ) {
                std::cout << "Stopping instrument #" << this->get_id() << " at t=" << (startFrame + this->mPlayedFrames)/this->orch->get_duration() << std::endl;
                this->mEnvelope.keyOff();
                this->mKeyedOff = true;
            }

            // If we're done
            if(this->orch->get_t()*this->orch->get_duration() >= endFrame) {
                std::cout << "Instrument #" << this->get_id() << " done playing at t=" << (startFrame + this->mPlayedFrames)/this->orch->get_duration() << std::endl;
                this->mPlaying = false;
                break;
            }


        }
    }
    return frames;
}