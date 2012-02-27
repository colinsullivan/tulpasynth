/**
 *  @file       FallingBall.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "PhysicsEntity.h"

#include "b2CircleShape.h"
#include "b2Fixture.h"

#import "FallingBallModel.h"

/**
 *  @class  Ball that falls and collides with other entities.
 **/
@interface FallingBall : PhysicsEntity

- (void) initialize;

@end
