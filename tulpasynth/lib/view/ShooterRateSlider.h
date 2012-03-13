//
//  ShooterRateSlider.h
//  tulpasynth
//
//  Created by Colin Sullivan on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhysicsEntity.h"

#import "ShooterRateSliderArrow.h"

@interface ShooterRateSlider : PhysicsEntity

@property BOOL active;

@property (strong, nonatomic) ShooterRateSliderArrow* arrow;

@end
