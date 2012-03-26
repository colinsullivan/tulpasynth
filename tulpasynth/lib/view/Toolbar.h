/**
 *  @file       Toolbar.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import <Foundation/Foundation.h>
#include "b2PolygonShape.h"
#include "b2MouseJoint.h"

#import "PhysicsEntity.h"
#import "BlockObstacle.h"
#import "BlockModel.h"
#import "Shooter.h"
#import "TriObstacle.h"
#import "TriObstacleModel.h"

#import "Blackhole.h"
#import "BlackholeModel.h"

#import "AddingRing.h"



@interface Toolbar : PhysicsEntity

/**
 *  Wether or not the toolbox is completely closed (as in a drawer that is
 *  closed).
 **/
@property (nonatomic) BOOL closed;

/**
 *  Wether or not the toolbox is completely open.
 **/
@property (nonatomic) BOOL open;

- (void) animateOpen:(b2Vec2*)ringLocation;
- (void) animateClosed;

@property (strong, nonatomic) NSMutableArray* prototypes;

@property (strong, nonatomic) BlockObstacle* squarePrototype;
@property (strong, nonatomic) Shooter* shooterPrototype;
@property (strong, nonatomic) TriObstacle* triPrototype;
@property (strong, nonatomic) Blackhole* blackholePrototype;

@property (strong, nonatomic) AddingRing* addingRing;

@end
