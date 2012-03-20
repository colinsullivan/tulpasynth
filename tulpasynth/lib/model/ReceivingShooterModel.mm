//
//  ReceivingShooterModel.m
//  tulpasynth
//
//  Created by Colin Sullivan on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReceivingShooterModel.h"

@implementation ReceivingShooterModel

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
