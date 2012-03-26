/**
 *  @file       WildBallModel.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

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
