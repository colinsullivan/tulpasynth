//
//  WildBallModel.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhysicsEntityModel.h"

#include "Stk.h"

@interface WildBallModel : PhysicsEntityModel

@property (strong, nonatomic) NSDictionary* initialLinearVelocity;

/**
 *  Pitch embued on ball by other entity.
 **/
@property (strong, nonatomic) NSNumber* pitchIndex;

/**
 *  Amount of energy in ball (i.e. number of collisions remaining before death)
 **/
@property (strong, nonatomic) NSNumber* energy;

@end
