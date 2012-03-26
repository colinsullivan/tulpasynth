/**
 *  @file       PolygonObstacle.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "Obstacle.h"

#include "b2PolygonShape.h"
#include "b2Fixture.h"


@interface PolygonObstacle : Obstacle

/**
 *  Destroy shape and fixture.
 **/
- (void) destroyShape;
/**
 *  Create shape and fixture, deleting if currently exists.
 **/
- (void) createShape;

/**
 *  Set width and height at the same time.
 **/
- (void)setWidth:(float)aWidth withHeight:(float)aHeight;
@end
