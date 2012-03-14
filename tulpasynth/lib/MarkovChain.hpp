/**
 *  @file       MarkovChain.hpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#ifndef _MARKOVCHAIN_H_
#define _MARKOVCHAIN_H_

#include <vector>
#include <iostream>

/**
 *  @class  1st order markov lookup table
 **/
class MarkovChain
{
public:
    /**
     *  Constructor for a MarkovChain object, must take a 2 dimensional
     *  array of probabilities.
     *
     *  @param  someProbabilities  Pointer to 2D vector of probs.
     **/
    MarkovChain(std::vector< std::vector<float> >* someProbabilities);
    ~MarkovChain(){};

    /**
     *  Interface for producing the index value of the next state.
     **/
    virtual int nextIndex();

protected:
    /**
     *  Reference to the 2D array of probabilities.
     *
     *  Example:
     *                      Next pitch:
     *                  A       B       C             
     *  Previous    A  1/3     2/3     0/3
     *  pitch:      B  0/3     1/3     2/3
     *              C  2/3     0/3     1/3
     **/
    std::vector< std::vector<float> >* _probabilities;

    /**
     *  Internal method to generate a random seed and choose an index
     *  in a given row.
     *
     *  @param  row  Row to return index from.
     **/
    int _findInRow(std::vector<float>& row);

    /**
     *  Index of previous event.
     **/
    int prevIndex;

};

#endif