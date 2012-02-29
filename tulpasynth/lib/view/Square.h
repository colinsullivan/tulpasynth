/**
 *  @file       Square.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import <Foundation/Foundation.h>

#include "b2PolygonShape.h"
#include "b2Fixture.h"

#import "Obstacle.h"

#import "FMPercussion.hpp"

#import "SquareModel.h"

/**
 *  @class A rectangular obstacle.
 **/
@interface Square : Obstacle

//@property b2PolygonShape* square;

@property instruments::FMPercussion* instr;

- (void) initialize;

- (void)resize;

- (void) handleCollision:(float)collisionStrength;


@end
