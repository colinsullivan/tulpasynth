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
#import "Square.h"
#import "SquareModel.h"
#import "Shooter.h"

@interface RadialToolbox : PhysicsEntity

@property BOOL active;

@property (strong, nonatomic) NSMutableArray* prototypes;

@property (strong, nonatomic) Square* squarePrototype;
@property (strong, nonatomic) Shooter* shooterPrototype;

- (void) initialize;

@end
