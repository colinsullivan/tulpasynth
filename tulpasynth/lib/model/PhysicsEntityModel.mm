//
//  PhysicsEntityModel.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhysicsEntityModel.h"

@implementation PhysicsEntityModel

@synthesize initialPosition;

- (NSMutableArray*) serializableAttributes {
    NSMutableArray* attributes = [super serializableAttributes];
    
    [attributes addObject:@"initialPosition"];
    
    return attributes;
}

@end
