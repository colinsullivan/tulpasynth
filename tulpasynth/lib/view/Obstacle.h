/**
 *  @file       Obstacle.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "PhysicsEntity.h"

#include "b2Math.h"

#import "ObstacleModel.h"

@class tulpaViewController;

/**
 *  @class Abstraction around touch handlers for an obstacle that the falling
 *  balls can collide with.
 **/
@interface Obstacle : PhysicsEntity


@end
