/**
 *  @file       ShooterRateSlider.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "PhysicsEntity.h"

#import "ShooterRateSliderArrow.h"

@interface ShooterRateSlider : PhysicsEntity

@property (strong, nonatomic) ShooterRateSliderArrow* arrow;
/**
 *  What the shooting rate was before user started changing it.
 **/
@property (strong, nonatomic) NSNumber* rateBeforeSliding;


@end
