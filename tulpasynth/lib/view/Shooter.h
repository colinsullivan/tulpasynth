/**
 *  @file       Shooter.h
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
#import "ShooterModel.h"

/**
 *  @class A shooting obstacle.
 **/
@interface Shooter : Obstacle

- (void) initialize;
- (void) setWidth:(float)width;
-(void)prepareToDraw;
- (b2BodyType)bodyType;


@end
