/**
 *  @file       PhysicsEntityModel.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

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

+ (NSMutableDictionary*) defaultAttributes {
    NSMutableDictionary* defaults = [super defaultAttributes];
    
    [defaults setValue:[NSNumber numberWithFloat:0.0] forKey:@"angle"];
    
    return defaults;
}

- (void) initialize {
    
    if(!self.position) {
        self.position = [NSMutableDictionary dictionaryWithDictionary:self.initialPosition];
    }
    
    [super initialize];
}

@end
