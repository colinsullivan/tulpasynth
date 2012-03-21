/**
 *  @file       BlockObstacle.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import <Foundation/Foundation.h>

#import "PolygonObstacle.h"

#import "BendingFMPercussion.hpp"

#import "BlockModel.h"

/**
 *  @class A rectangular obstacle.
 **/
@interface BlockObstacle : PolygonObstacle

//@property b2PolygonShape* square;

@property instruments::BendingFMPercussion* instr;


@end
