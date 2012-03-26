/**
 *  @file       ShooterRateSliderArrow.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "PhysicsEntity.h"

#include "b2PolygonShape.h"
#include "ShooterModel.h"

@class ShooterRateSlider;

@interface ShooterRateSliderArrow : PhysicsEntity

/**
 *  Reference to the slider we're attached to.
 **/
@property (weak, nonatomic) ShooterRateSlider* slider;

/**
 *  Initialize with slider.
 **/
- (id)initWithController:(tulpaViewController *)theController withModel:(Model *)aModel withShooterRateSlider:(ShooterRateSlider*)aSlider;

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
@end
