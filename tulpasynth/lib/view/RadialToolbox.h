//
//  RadialToolbox.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "b2CircleShape.h"
#include "b2Fixture.h"

#import "PhysicsEntity.h"
#import "BlockObstacle.h"
#import "BlockModel.h"
#import "Shooter.h"
#import "TriObstacle.h"
#import "TriObstacleModel.h"

@interface RadialToolbox : PhysicsEntity

@property BOOL active;

@property (strong, nonatomic) NSMutableArray* prototypes;

@property (strong, nonatomic) BlockObstacle* squarePrototype;
@property (strong, nonatomic) Shooter* shooterPrototype;
@property (strong, nonatomic) TriObstacle* triPrototype;

- (void) initialize;

@end
