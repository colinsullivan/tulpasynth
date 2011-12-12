/**
 *  @file       Orchestra.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#include "Orchestra.hpp"
#include "instruments/Instrument.hpp"

Orchestra::Orchestra()  {
    this->t = 0.0;
    this->duration = 4*SAMPLE_RATE;
    this->instrs = new std::map<int, instruments::Instrument*>();

    /**
     *  ID of new instruments
     **/
    this->NEXT_INSTRUMENT_ID = 1;
};

void Orchestra::add_instrument(instruments::Instrument* anInstrument) {
    this->instrs->insert(std::pair<int, instruments::Instrument*>(anInstrument->get_id(), anInstrument));
};

void Orchestra::delete_instrument(int instrumentId) {
    this->instrs->erase(instrumentId);
};

instruments::Instrument* Orchestra::get_instrument(int instrumentId) {
    std::map<int, instruments::Instrument*>::iterator result = this->instrs->find(instrumentId);

    if(result == this->instrs->end()) {
        std::cerr << "Instrument with id " << instrumentId << " not found." << std::endl;
        return NULL;
    }
    else {
        return (*result).second;
    }
};

std::map<int, instruments::Instrument*>* Orchestra::get_instruments() {
    return this->instrs;
}
