/**
 *  @file       Blackhole.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "Obstacle.h"

#include "b2CircleShape.h"
#include "b2Fixture.h"

#include <vector>

#include "RAMpler.hpp"

#import "BlackholeModel.h"

@interface Blackhole : Obstacle {
    /**
     *  Instruments we will use to sonify collisions.  One for each possible
     *  pitch.
     **/
    std::vector<instruments::RAMpler*> instrs;
}

@end
