/**
 *  @file       ShooterModel.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

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
@property (strong, nonatomic) NSMutableArray* shotTimes;

///**
// *  Index of next shot time in list of shot times
// **/
//@property (strong, nonatomic) NSNumber* nextShotIndex;

+ (NSNumber*) maxRate;
+ (NSNumber*) minRate;

/**
 *  Called when rate is done being modified, and we're ready to synchronize
 **/
- (void) generateNewShotTimes;

@end
