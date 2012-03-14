/**
 *  @file       SecondOrderMarkovChain.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#include "SecondOrderMarkovChain.hpp"

SecondOrderMarkovChain::SecondOrderMarkovChain(std::vector< std::vector<float> >* someProbabilities) : MarkovChain::MarkovChain(someProbabilities) {
        
    prevPrevIndex = 0;
}

int SecondOrderMarkovChain::nextIndex() {
    int rowSize = (*_probabilities)[0].size();
    
    std::vector<float>* row = &(*_probabilities)[prevPrevIndex*rowSize + prevIndex];
    int index = _findInRow((*row));
    
    prevPrevIndex = prevIndex;
    prevIndex = index;
    return index;
}