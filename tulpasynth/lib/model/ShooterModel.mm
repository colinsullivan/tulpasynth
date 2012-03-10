//
//  ShooterModel.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShooterModel.h"

@implementation ShooterModel

@synthesize rate, nextShotTime;

- (NSMutableArray*) serializableAttributes {
    NSMutableArray* attrs = [super serializableAttributes];
    
    [attrs addObject:@"rate"];
    [attrs addObject:@"nextShotTime"];
    
    return attrs;
}

+ (NSMutableDictionary*) defaultAttributes {
    NSMutableDictionary* defaults = [super defaultAttributes];
    
    [defaults setValue:[NSNumber numberWithFloat:5.0] forKey:@"width"];
    [defaults setValue:[NSNumber numberWithFloat:5.0] forKey:@"height"];
    [defaults setValue:[NSNumber numberWithFloat:1.0] forKey:@"rate"];
    
    return defaults;
}

@end
