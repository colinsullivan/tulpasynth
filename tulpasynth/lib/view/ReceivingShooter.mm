/**
 *  @file       ReceivingShooter.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/


#import "ReceivingShooter.h"

#import "tulpaViewController.h"

@implementation ReceivingShooter

- (void) initializeTextures {
    self.effect.texture2d0.name = self.controller.receivingShooterTexture.name;
    self.effect1.texture2d0.name = self.controller.receivingShooterGlowingTexture.name;
}


- (void) setSelected:(BOOL)isSelected {
    [super setSelected:isSelected];
    
    // never show rate slider.
    self.rateSlider.active = false;
}

- (void) advanceToNextShot {
    ReceivingShooterModel* model = ((ReceivingShooterModel*)self.model);
//    NSLog(@"model.shotTimes: %@", model.shotTimes);
    
    if ([model.shotTimes count] == 0) {
        return;
    }

    [super advanceToNextShot];
    
    // if we still need to shoot our current ball
    if (self.nextShotTime && [self.nextShotTime timeIntervalSinceNow] > 0) {
        // wait.
        return;
    }
    
    if ([self.nextShotIndex intValue] > 0) {
//        NSLog(@"ReceivingShooter determining rate of next shot");
//        // determine rate based on next shot time and the one after that
//        NSDate* nextNextShotTime = [self.shotTimes objectAtIndex:[self.nextShotIndex intValue]+1];
//        NSLog(@"nextNextShotTime: %@", nextNextShotTime);
//        // determine own rate based on time between shots
//        model.rate = [NSNumber numberWithDouble:(1.0 / [nextNextShotTime timeIntervalSinceDate:self.nextShotTime])];   
//        NSLog(@"model.rate: %@", model.rate);
        
        // determine rate based on prev shot time and next shot time
        NSDate* prevShotTime = [self.shotTimes objectAtIndex:[self.nextShotIndex intValue]-1];
        NSLog(@"prevShotTime: %f", [prevShotTime timeIntervalSince1970]);
        NSLog(@"nextShotTime: %f", [self.nextShotTime timeIntervalSince1970]);
        NSTimeInterval prevToNext = [self.nextShotTime timeIntervalSinceDate:prevShotTime];
        NSLog(@"prevToNext: %f", prevToNext);
        model.rate = [NSNumber numberWithDouble:(1.0 / prevToNext)];
        NSLog(@"model.rate: %@", model.rate);
        
    }
    else {
        NSLog(@"not enough shot times to determine rate");
    }
    
    if ([self.nextShotIndex integerValue] < [model.nextPitchIndexes count]) {
        self.nextPitchIndex = [model.nextPitchIndexes objectAtIndex:[self.nextShotIndex integerValue]];
    }

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

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    ReceivingShooterModel* model = ((ReceivingShooterModel*)self.model);
    if ([keyPath isEqualToString:@"shotTimes"]) {
        self.shotTimes = model.shotTimes;

        // if we still haven't shot a ball, and just received our first balls
        if ([model.shotTimes count] > 1 && [self.nextShotIndex integerValue] < 0) {
            self.nextShotIndex = [NSNumber numberWithInt:0];
            self.nextShotTime = [model.shotTimes objectAtIndex:0];
            self.prevTimeUntilNextShot = [self.nextShotTime timeIntervalSinceNow];
            
            // calculate initial rate
            NSTimeInterval timeTilNext = [[model.shotTimes objectAtIndex:1] timeIntervalSinceDate:self.nextShotTime];
            model.rate = [NSNumber numberWithDouble:(1.0 / timeTilNext)];
            
            [self advanceToNextShot];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end
