/**
 *  @file       RadialToolbox.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#include "b2CircleShape.h"
#include "b2Fixture.h"

#import "PhysicsEntity.h"
#import "BlockObstacle.h"
#import "BlockModel.h"
#import "Shooter.h"
#import "TriObstacle.h"
#import "TriObstacleModel.h"

#import "Blackhole.h"
#import "BlackholeModel.h"

@interface RadialToolbox : PhysicsEntity

@property (strong, nonatomic) NSMutableArray* prototypes;

@property (strong, nonatomic) BlockObstacle* squarePrototype;
@property (strong, nonatomic) Shooter* shooterPrototype;
@property (strong, nonatomic) TriObstacle* triPrototype;
@property (strong, nonatomic) Blackhole* blackholePrototype;

- (void) initialize;

@end
