//
//  BlackholeModel.h
//  tulpasynth
//
//  Created by Colin Sullivan on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObstacleModel.h"

@interface BlackholeModel : ObstacleModel

/**
 *  A list of times that this blackhole ate balls.
 **/
@property (strong, nonatomic) NSMutableArray* eatenBallTimes;

/**
 *  A list of pitch indexes of the balls that were eaten.
 **/
@property (strong, nonatomic) NSMutableArray* pitchIndexes;

@end
