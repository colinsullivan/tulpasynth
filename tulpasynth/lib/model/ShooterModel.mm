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

+ (NSNumber*) maxRate {
    static NSNumber* theMaxRate;
    if (!theMaxRate) {
        theMaxRate = [NSNumber numberWithFloat:5.5];
    }
    return theMaxRate;
}

+ (NSNumber*) minRate {
    static NSNumber* theMinRate;
    if (!theMinRate) {
        theMinRate = [NSNumber numberWithFloat:0.25];
    }
    return theMinRate;
}

- (void) setRate:(NSNumber *)aRate {
    NSNumber* minRate = [[self class] minRate];
    NSNumber* maxRate = [[self class] maxRate];
    
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
//    [attrs addObject:@"shotTimes"];
    
    return attrs;
}

+ (NSMutableDictionary*) defaultAttributes {
    NSMutableDictionary* defaults = [super defaultAttributes];
    
    [defaults setValue:[NSNumber numberWithFloat:5.0] forKey:@"width"];
    [defaults setValue:[NSNumber numberWithFloat:5.0] forKey:@"height"];
    [defaults setValue:[NSNumber numberWithFloat:1.0] forKey:@"rate"];
//    [defaults setValue:[[NSMutableArray alloc] init] forKey:@"shotTimes"];
    
    return defaults;
}

@end
