/**
 *  @file       Instrument.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#include "Instrument.hpp"

#include "../Orchestra.hpp"

instruments::Instrument::Instrument(Orchestra* anOrch, Json::Value initialAttributes) {
    this->orch = anOrch;

    // If the initial attributes did not include an id, error
    if(initialAttributes.get("id", false) == false) {
        std::cerr << "New instrument did not have an id." << std::endl;
        return;
    }
    else {
        // Read in all attributes
        this->attributes = initialAttributes;
        this->orch->add_instrument(this);
    }

};