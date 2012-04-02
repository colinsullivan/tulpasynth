/**
 *  @file       Shooter.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import <Foundation/Foundation.h>

#import "ShooterBase.h"
#import "ShooterModel.h"


#import "ShooterRateSlider.h"

/**
 *  @class A shooting obstacle.
 **/
@interface Shooter : ShooterBase


/**
 *  Time we fired the last ball.
 **/
//@property (strong, nonatomic) NSDate* lastShotTime;


/**
 *  Wether or not we've shot a ball this round.
 **/
//@property (nonatomic) BOOL waitingToShoot;

///**
// *  Last measure taken of the animation 
// **/
//@property float lastPerc;



/**
 *  Radial menu that pops up to change rate
 **/
@property (strong, nonatomic) ShooterRateSlider* rateSlider;


@end
