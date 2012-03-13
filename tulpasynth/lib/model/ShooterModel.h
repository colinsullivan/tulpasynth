//
//  ShooterModel.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObstacleModel.h"

#include "Stk.h"

@interface ShooterModel : ObstacleModel

/**
 *  Rate at which this shooter will fire balls (in Hz).
 **/
@property (strong, nonatomic) NSNumber* rate;

/**
 *  Time the next shot will occur
 **/
@property (strong, nonatomic) NSDate* nextShotTime;

/**
 *  List of all shot times in order
 **/
//@property (strong, nonatomic) NSMutableArray* shotTimes;

@end
