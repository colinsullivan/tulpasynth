//
//  ReceivingShooter.m
//  tulpasynth
//
//  Created by Colin Sullivan on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReceivingShooter.h"

#import "tulpaViewController.h"

@implementation ReceivingShooter

- (void) advanceToNextShot {
    ReceivingShooterModel* model = ((ReceivingShooterModel*)self.model);
//    NSLog(@"model.shotTimes: %@", model.shotTimes);

    [super advanceToNextShot];
    
    

    if ([self.nextShotIndex intValue]+1 < [self.shotTimes count]) {
        // determine rate based on next shot time and the one after that
        NSDate* nextNextShotTime = [self.shotTimes objectAtIndex:[self.nextShotIndex intValue]+1];
        // determine own rate based on time between shots
        model.rate = [NSNumber numberWithDouble:[nextNextShotTime timeIntervalSinceDate:self.nextShotTime]];        
    }
//    else {
//        NSLog(@"not enough shot times to determine rate");
//    }
}

//- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    
//    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    
//
//    if ([keyPath isEqualToString:@"rate"]) {
//        if ([model.rate floatValue] == 0.0) {
//            NSLog(@"self.nextShotTime: %@", self.nextShotTime);
//        }
//        //        
//        ////        if (model.ignoreUpdates) {
//        ////            // determine own next shot time
//        ////            model.nextShotTime = [NSDate dateWithTimeIntervalSinceNow:(1.0/[model.rate floatValue])];
//        ////        }
//    }
//
//}


@end
