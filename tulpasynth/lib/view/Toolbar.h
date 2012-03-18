//
//  Toolbar.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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

- (void) animateOpen;
- (void) animateClosed;

@property (strong, nonatomic) NSMutableArray* prototypes;

@property (strong, nonatomic) BlockObstacle* squarePrototype;
@property (strong, nonatomic) Shooter* shooterPrototype;
@property (strong, nonatomic) TriObstacle* triPrototype;
@property (strong, nonatomic) Blackhole* blackholePrototype;

@end
