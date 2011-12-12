/**
 *  @file       Earth.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#include "Earth.hpp"

instruments::Earth::Earth(Orchestra* anOrch, Json::Value initialAttributes) : instruments::RAMpler::RAMpler(anOrch, initialAttributes) {

    initialAttributes["gain"] = 0.25;
    this->set_attributes(initialAttributes);

    std::stringstream filepath;

    filepath << stk::Stk::rawwavePath() << "Earth.aif";

    this->set_clip(filepath.str());

    this->finish_initializing();
}