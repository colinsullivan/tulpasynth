/**
 *  @file       PricklySynth.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#include "PricklySynth.hpp"


instruments::PricklySynth::PricklySynth(Orchestra* anOrch, Json::Value initialAttributes) : instruments::PitchedInstrument::PitchedInstrument(anOrch, initialAttributes) {

    this->pitches[16] = 440.0000;
    this->pitches[17] = 369.9944;
    this->pitches[18] = 311.1270;
    this->pitches[19] = 261.6256;
    this->pitches[20] = 220.0000;
    this->pitches[21] = 184.9972;
    this->pitches[22] = 155.5635;
    this->pitches[23] = 130.8128;
    this->pitches[24] = 110.0000;
    this->pitches[25] = 92.4986;
    this->pitches[26] = 77.7817;
    this->pitches[27] = 65.4064;
    this->pitches[28] = 55.0000;
    this->pitches[29] = 46.2493;
    this->pitches[30] = 38.8909;
    this->pitches[31] = 32.7032;


    this->mMinFilterFreq = 110;
    this->mMaxFilterFreq = 2000;


    // BPF f;
    this->mFundSawGain = 1.0;
    this->mFundSaw.setHarmonics(10);

    this->mFundSineGain = 0.9;

    this->mLowSineGain = 0.1;

    this->mJuiceGain = 1;
    this->mJuice.setFrequency(55);

    this->mSweeper.setFrequency(0.15);
    this->mSweeperGain = 1;

    // Note on in 1/10 of a second
    this->mEnvelope.setTime(0.10);

    this->m_y1 = 0;
    this->m_y2 = 0;

    this->filterFreq(this->mMinFilterFreq);

    this->get_attributes()["gain"] = 0.30;

    this->mPlayedFrames = 0;

    this->set_attributes(initialAttributes);

    this->finish_initializing();
};

void instruments::PricklySynth::freq(stk::StkFloat aFreq) {
    instruments::PitchedInstrument::freq(aFreq);

    this->mFundSaw.setFrequency(aFreq);
    this->mFundSine.setFrequency(aFreq);
    this->mLowSine.setFrequency(aFreq/4);

}

// void instruments::PricklySynth::set_attributes(Json::Value newAttributes) {

//     // Calculate duration from start and end times
//     float dur = newAttributes["endTime"] - newAttributes["startTime"];

//     bool durationHasChanged = false;

//     instruments::Instrument::set_attributes(newAttributes);



// }

void instruments::PricklySynth::play() {
    PitchedInstrument::play();

    // Restart filter
    // this->mSweeper.addPhase(1-this->mSweeper.lastOut());

    // Set filter to oscillate once during entire note
    // float durationSeconds = (
    //     (this->get_attributes()["endTime"].asFloat() - this->get_attributes()["startTime"].asFloat())
    //     *(float)this->orch->get_duration()
    // )/(float)SAMPLE_RATE;
    // this->mSweeper.setFrequency(durationSeconds);

    this->mEnvelope.keyOn();
    this->mPlayedFrames = 0;
    this->mKeyedOff = false;
};


stk::StkFrames& instruments::PricklySynth::next_buf(stk::StkFrames& frames, double nextBufferT) {
    int durationSamples = floor(
        (this->get_attributes()["endTime"].asFloat() - this->get_attributes()["startTime"].asFloat())
        *(float)this->orch->get_duration()
    );

    double startTime = this->get_attributes()["startTime"].asDouble();
    // Sample (relative to loop duration) on which this synth should start
    double startFrame = startTime*(double)this->orch->get_duration();

    double endTime = this->get_attributes()["endTime"].asDouble();
    // Sample (relative to loop duration) on which this synth should end
    double endFrame = endTime*(double)this->orch->get_duration();

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

            // If this instrument is looping forever
            if(startTime < 0.02 && endTime > 0.98) {
                continue;
            }
            // If this instrument should be stopped at some point
            else {
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
                    // std::cout << "Stopping instrument #" << this->get_id() << " at t=" << (startFrame + this->mPlayedFrames)/this->orch->get_duration() << std::endl;
                    this->mEnvelope.keyOff();
                    this->mKeyedOff = true;
                }

                // If we're done
                if(this->orch->get_t()*this->orch->get_duration() >= endFrame) {
                    // std::cout << "Instrument #" << this->get_id() << " done playing at t=" << (startFrame + this->mPlayedFrames)/this->orch->get_duration() << std::endl;
                    this->mPlaying = false;
                    break;
                }                
            }


        }
    }
    return frames;
}