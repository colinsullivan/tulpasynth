/**
 *  @file       Glitch.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/


#include "Glitch.hpp"


instruments::Glitch::Glitch(Orchestra* anOrch, int numClips, Json::Value initialAttributes) : instruments::Instrument::Instrument(anOrch) {

    this->mNumClips = numClips;
    this->mCurrentClip = NULL;

    for(int i = 0; i < numClips; i++) {
        std::stringstream filepath;

        filepath << Stk::rawwavePath() << "Glitch_";

        if(i < 10) {
            filepath << "0";
        }

        filepath << i << ".aif";

        // Load wavefile
        this->attacks_.push_back(new FileWvIn(filepath.str(), true));
    }

    this->mDisabled = initialAttributes["disabled"].asBool();

    this->mStartTime = initialAttributes["startTime"].asDouble();

    this->id = initialAttributes["id"].asInt();
}

FileWvIn* instruments::Glitch::new_current_clip() {
    // Get random clip
    this->mCurrentClip = this->attacks_[rand() % this->mNumClips];
    return this->mCurrentClip;
}

FileWvIn* instruments::Glitch::get_current_clip() {
    FileWvIn* clip = NULL;

    if(this->mCurrentClip) {
        clip = this->mCurrentClip;
    }
    else {
        clip = this->new_current_clip();
    }

    return clip;
}

void instruments::Glitch::noteOn( StkFloat frequency, StkFloat amplitude ) {
    this->noteOff(0.5);
    this->new_current_clip();
    this->keyOn();
};
