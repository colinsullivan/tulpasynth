/**
 *  @file       ReceivingShooterModel.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "ReceivingShooterModel.h"

@implementation ReceivingShooterModel

@synthesize nextPitchIndexes;

- (NSMutableArray*)serializableAttributes {
    NSMutableArray* attrs = [super serializableAttributes];
    
    [attrs addObject:@"nextPitchIndexes"];
    
    return attrs;
}

+ (NSMutableDictionary*)defaultAttributes {
    NSMutableDictionary* attrs = [super defaultAttributes];
    
    [attrs setValue:[NSMutableArray array] forKey:@"nextPitchIndexes"];
    
    return attrs;
}

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
        // shooterModel can have a rate of 0 which means it needs to be 
        // determined by the client
        theMinRate = [NSNumber numberWithFloat:0.0];
    }
    return theMinRate;
}

- (void) generateNewShotTimes {
    return;
}


@end
