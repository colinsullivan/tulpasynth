/**
 *  @file       ReceivingShooter.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "ShooterBase.h"

#import "ReceivingShooterModel.h"

#include "RAMpler.hpp"

@interface ReceivingShooter : ShooterBase

@property (strong, nonatomic) NSNumber* nextShotRate;

@end
