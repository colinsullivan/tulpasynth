//
//  RadialToolbox.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "b2CircleShape.h"
#include "b2Fixture.h"

#import "PhysicsEntity.h"

@interface RadialToolbox : PhysicsEntity

@property BOOL active;

- (void) initialize;

@end
