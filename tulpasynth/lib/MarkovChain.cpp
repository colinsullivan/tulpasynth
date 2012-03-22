/**
 *  @file       MarkovChain.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#include "MarkovChain.hpp"

MarkovChain::MarkovChain(std::vector< std::vector<float> >* someProbabilities) {
    this->_probabilities = someProbabilities;

    srandom(time(0));

    // Sum each row to ensure they add up to ~ 1.0
    for(int i = 0; i < _probabilities->size(); i++) {
        float sum = 0.0;

        for(int j = 0; j < (*_probabilities)[i].size(); j++) {
            sum += (*_probabilities)[i][j];
        }

        if (
            // if sum of row is not 1.0
            sum != 1.0
            &&
            // and sum is not very close to 1.0
            !(sum > 0.99 && sum < 1.01)
        ) {
            // Provide warning.  Markov chains will still work, but 
            // the states will not be calculated properly.
            std::cout << "(MarkovChain.cpp) WARNING: Row " << i << " sums to " << sum << std::endl;
        }
    }


    this->prevIndex = 0;
}

int MarkovChain::_findInRow(std::vector<float>& row) {
    // generate random seed
    float seed = random()/(float)RAND_MAX;
    
    // Keep track of current largest probability value, and the column index
    float currentLargestProbability = -1.0;
    int currentLargestProbabilityIndex = -1;

    int j = 0;

    // for each possible probability in row
    while (j < row.size()) {
        // if probability is a candidate
        if (row[j] < seed && row[j] >= currentLargestProbability) {
            // if it is equal to other candidate, randomly choose between current and new
            bool maybe = (random()/(float)RAND_MAX < 0.5);
            if (row[j] != currentLargestProbability || maybe) {
                currentLargestProbabilityIndex = j;
                currentLargestProbability = row[j];
            }
        }
        j++;
    }

    return currentLargestProbabilityIndex;
}


int MarkovChain::nextIndex() {
    // using row pointed to by previous state, find next row
    std::vector<float>* prevRow = &(*_probabilities)[prevIndex];
    int index = _findInRow((*prevRow));
    prevIndex = index;
    return index;
}
