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

#import "ShooterRateSlider.h"

/**
 *  @class A shooting obstacle.
 **/
@interface Shooter : Obstacle

- (void) initialize;
- (void) setWidth:(float)width;
-(void)prepareToDraw;
- (b2BodyType)bodyType;

@property (strong, nonatomic) GLKBaseEffect* effect1;

@property float glow;

/**
 *  Instrument to play each time ball is fired 
 **/
@property instruments::RAMpler* instr;

/**
 *  Time we fired the last ball.
 **/
@property (strong, nonatomic) NSDate* lastShotTime;

/**
 *  Time when the next ball will be fired
 **/
@property (strong, nonatomic) NSDate* nextShotTime;

/**
 *  Index into the model's shotTimes array
 **/
@property (strong, nonatomic) NSNumber* nextShotIndex;

/**
 *  Last measure taken of the time until the next shot will be fired.
 **/
@property NSTimeInterval prevTimeUntilNextShot;

/**
 *  Wether or not we've shot a ball this round.
 **/
//@property (nonatomic) BOOL waitingToShoot;

///**
// *  Last measure taken of the animation 
// **/
//@property float lastPerc;

/**
 *  If we're currently animating a "shot"
 **/
@property (nonatomic) BOOL animating;

- (void) shootBall;

/**
 *  Radial menu that pops up to change rate
 **/
@property (strong, nonatomic) ShooterRateSlider* rateSlider;

/**
 *  What the shooting rate was before user started changing it.
 **/
@property (strong, nonatomic) NSNumber* rateBeforeSliding;

- (void) advanceToNextShot;


@end
