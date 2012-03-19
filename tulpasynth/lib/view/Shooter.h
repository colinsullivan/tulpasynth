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

#include "LoopingRAMpler.hpp"

#import "ShooterRateSlider.h"

/**
 *  @class A shooting obstacle.
 **/
@interface Shooter : Obstacle


@property float glow;

/**
 *  Instrument to play each time ball is fired 
 **/
@property instruments::LoopingRAMpler* instr;

/**
 *  Time we fired the last ball.
 **/
//@property (strong, nonatomic) NSDate* lastShotTime;

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
/**
 *  Percent of animation that is complete (0 to 1)
 **/
@property (nonatomic) float animatingPerc;
@property (nonatomic) float lastAnimatingPerc;

- (void) startAnimating;

- (void) shootBall;

/**
 *  Cache shot times from model
 **/
@property (strong, nonatomic) NSMutableArray* shotTimes;

/**
 *  Radial menu that pops up to change rate
 **/
@property (strong, nonatomic) ShooterRateSlider* rateSlider;


- (void) advanceToNextShot;


@end
