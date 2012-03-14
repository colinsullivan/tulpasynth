/**
 *  @file       SecondOrderMarkovChain.hpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#ifndef _SECONDORDERMARKOVCHAIN_H_
#define _SECONDORDERMARKOVCHAIN_H_

#include "MarkovChain.hpp"

/**
 *  @class  A second order markov chain with rows in the probability table ordered
 *  a specific way.
 *
 *  @extends    MarkovChain
 **/
class SecondOrderMarkovChain : protected MarkovChain
{
public:
    SecondOrderMarkovChain(std::vector< std::vector<float> >* someProbabilities);
    ~SecondOrderMarkovChain(){};
    
    /**
     *  Override nextIndex method to utilize our second to last state as well
     *  as our last.
     **/
    virtual int nextIndex();

protected:
    /**
     *  The index used two states ago
     **/
    int prevPrevIndex;
};

#endif