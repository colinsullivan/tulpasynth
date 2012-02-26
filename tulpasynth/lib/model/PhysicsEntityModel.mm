//
//  PhysicsEntityModel.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhysicsEntityModel.h"

@implementation PhysicsEntityModel

@synthesize initialPosition, position, angle, height, width;

- (NSMutableArray*) serializableAttributes {
    NSMutableArray* attributes = [super serializableAttributes];
    
    [attributes addObject:@"initialPosition"];
    [attributes addObject:@"position"];
    [attributes addObject:@"angle"];
    [attributes addObject:@"height"];
    [attributes addObject:@"width"];
    
    return attributes;
}

- (void) initialize {
    
    [super initialize];
    
    if (!self.angle) {
        self.angle = [NSNumber numberWithFloat:0.0];
    }
    
    
    if(!self.position) {
        self.position = [NSMutableDictionary dictionaryWithDictionary:self.initialPosition];
    }
}

@end