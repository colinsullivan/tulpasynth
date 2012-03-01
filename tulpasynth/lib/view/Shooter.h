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

#import "WildBallModel.h"
#import "WildBall.h"

#include "RAMpler.hpp"

/**
 *  @class A shooting obstacle.
 **/
@interface Shooter : Obstacle

- (void) initialize;
- (void) setWidth:(float)width;
-(void)prepareToDraw;
- (b2BodyType)bodyType;

/**
 *  Instrument to play each time ball is fired 
 **/
@property instruments::RAMpler* instr;

/**
 *  Time we fired the last ball.
 **/
@property (strong, nonatomic) NSDate* lastShotTime;
/**
 *  Time the next shot will occur
 **/
@property (strong, nonatomic) NSDate* nextShotTime;

- (void) shootBall;


@end
