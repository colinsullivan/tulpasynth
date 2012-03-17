//
//  Blackhole.h
//  tulpasynth
//
//  Created by Colin Sullivan on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Obstacle.h"

#include "b2CircleShape.h"
#include "b2Fixture.h"

#include "RAMpler.hpp"

#import "BlackholeModel.h"

@interface Blackhole : Obstacle

@property (nonatomic) instruments::RAMpler* instr;

@end
