//
//  PolygonObstacle.h
//  tulpasynth
//
//  Created by Colin Sullivan on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
