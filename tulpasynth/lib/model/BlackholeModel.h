/**
 *  @file       BlackholeModel.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "ObstacleModel.h"

@interface BlackholeModel : ObstacleModel

/**
 *  A list of times that this blackhole ate balls.
 **/
@property (strong, nonatomic) NSMutableArray* eatenBallTimes;

/**
 *  A list of pitch indexes of the balls that were eaten.
 **/
@property (strong, nonatomic) NSMutableArray* eatenBallPitchIndexes;

@end
