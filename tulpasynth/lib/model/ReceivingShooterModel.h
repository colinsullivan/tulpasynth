/**
 *  @file       ReceivingShooterModel.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "ShooterModel.h"

@interface ReceivingShooterModel : ShooterModel

/**
 *  Pitch indexes to give to next balls that are shot
 **/
@property (strong, nonatomic) NSMutableArray* nextPitchIndexes;

@end
