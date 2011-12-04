/**
 *  @file       Earth.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#include "Earth.hpp"

instruments::Earth::Earth(Orchestra* anOrch, Json::Value initialAttributes) : instruments::RAMpler::RAMpler(anOrch, initialAttributes) {
    std::stringstream filepath;

    filepath << stk::Stk::rawwavePath() << "Earth.aif";

    this->set_clip(filepath.str());
}