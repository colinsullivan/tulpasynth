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

- (void) setRate:(NSNumber *)aRate {
    NSNumber* minRate = [NSNumber numberWithFloat:0.25];
    NSNumber* maxRate = [NSNumber numberWithFloat:5.5];
    
    if ([aRate floatValue] < [minRate floatValue]) {
        aRate = minRate;
    }
    else if ([aRate floatValue] > [maxRate floatValue]) {
        aRate = maxRate;
    }
    
    rate = aRate;
}

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
