//
//  ShooterRateSliderArrow.h
//  tulpasynth
//
//  Created by Colin Sullivan on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhysicsEntity.h"

#include "b2PolygonShape.h"
#include "ShooterModel.h"

@class ShooterRateSlider;

@interface ShooterRateSliderArrow : PhysicsEntity

/**
 *  Reference to the slider we're attached to.
 **/
@property (nonatomic) ShooterRateSlider* slider;

/**
 *  Initialize with slider.
 **/
- (id)initWithController:(tulpaViewController *)theController withModel:(Model *)aModel withShooterRateSlider:(ShooterRateSlider*)aSlider;

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
@end
