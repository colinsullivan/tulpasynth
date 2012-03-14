//
//  ShooterModel.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShooterModel.h"

@implementation ShooterModel

@synthesize rate, nextShotTime, shotTimes, nextShotIndex;

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
    [attrs addObject:@"shotTimes"];
    [attrs addObject:@"nextShotIndex"];
    
    return attrs;
}

+ (NSMutableDictionary*) defaultAttributes {
    NSMutableDictionary* defaults = [super defaultAttributes];
    
    [defaults setValue:[NSNumber numberWithFloat:5.0] forKey:@"width"];
    [defaults setValue:[NSNumber numberWithFloat:5.0] forKey:@"height"];
    [defaults setValue:[NSNumber numberWithFloat:1.0] forKey:@"rate"];
    [defaults setValue:[NSNumber numberWithInt:0] forKey:@"nextShotIndex"];
    
    
    return defaults;
}

// ghetto serialize and deserialize for shotTimes
- (NSMutableDictionary*) serialize {
    NSMutableDictionary* attributes = [super serialize];
    
    NSMutableArray* shotTimesDates = [attributes objectForKey:@"shotTimes"];
    NSMutableArray* shotTimeNumbers = [[NSMutableArray alloc] init];
    for (NSDate* shotTime in shotTimesDates) {
        [shotTimeNumbers addObject:[NSNumber numberWithDouble:[shotTime timeIntervalSince1970]]];
    }
    [attributes setValue:shotTimeNumbers forKey:@"shotTimes"];
    return attributes;
}

- (void) deserialize:(NSMutableDictionary *)attributes {
    if (!self.ignoreUpdates) {
        [super deserialize:attributes];
        
        NSMutableArray* shotTimeNumbers = [attributes valueForKey:@"shotTimes"];
        NSMutableArray* shotTimeDates = [[NSMutableArray alloc] init];
        for (NSNumber* shotTimeNumber in shotTimeNumbers) {
            [shotTimeDates addObject:[NSDate dateWithTimeIntervalSince1970:[shotTimeNumber doubleValue]]];
        }
        self.shotTimes = shotTimeDates;
    }
}

- (void) initialize {
    if (!self.shotTimes) {
        NSDate* now = [NSDate dateWithTimeIntervalSinceNow:0.0];
        self.shotTimes = [[NSMutableArray alloc] initWithObjects:
                          now,
                          // next shot is 1 second in the future
                          [NSDate dateWithTimeInterval:1.0 sinceDate:now],
                          // then 1 second after that
                          [NSDate dateWithTimeInterval:2.0 sinceDate:now],
                          nil];        
    }
    else {
        // shot times were initialized as doubles, convert to dates
        NSMutableArray* shotTimeNumbers = self.shotTimes;
        NSMutableArray* shotTimeDates = [[NSMutableArray alloc] init];
        for (NSNumber* shotTimeNumber in shotTimeNumbers) {
            [shotTimeDates addObject:[NSDate dateWithTimeIntervalSince1970:[shotTimeNumber doubleValue]]];
        }
        self.shotTimes = shotTimeDates;
    }
    [super initialize];
}
@end
