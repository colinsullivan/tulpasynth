//
//  ShooterBase.h
//  tulpasynth
//
//  Created by Colin Sullivan on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Obstacle.h"

#import "ShooterModel.h"

#include "b2PolygonShape.h"
#include "b2Fixture.h"

#import "WildBallModel.h"
#import "WildBall.h"

#include "Instrument.hpp"


@interface ShooterBase : Obstacle

/**
 *  Amount this shooter is "glowing".
 **/
@property float glow;

/**
 *  Instrument to play each time ball is fired 
 **/
@property instruments::Instrument* instr;


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
 *  Pitch index of next ball.
 **/
@property NSNumber* nextPitchIndex;

/**
 *  If we're currently animating a "shot"
 **/
@property (nonatomic) BOOL animating;
/**
 *  Percent of animation that is complete (0 to 1)
 **/
@property (nonatomic) float animatingPerc;
/**
 *  Last measure of animatingPerc
 **/
@property (nonatomic) float lastAnimatingPerc;


- (void) startAnimating;

- (void) shootBall;

/**
 *  Cache shot times from model
 **/
@property (strong, nonatomic) NSMutableArray* shotTimes;

/**
 *  Attempt to advance to the next shot in queue.  Returns true if 
 *  shot should be advanced.
 **/
- (BOOL) advanceToNextShot;

@end
