//
//  StaticPhysicsEntity.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PhysicsEntity.h"

@interface StaticPhysicsEntity : PhysicsEntity

- (id)initWithWorld:(b2World*)world;

@end
