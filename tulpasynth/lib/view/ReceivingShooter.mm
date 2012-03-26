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

    [super advanceToNextShot];
    
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
        model.rate = [NSNumber numberWithDouble:(1.0 / [self.nextShotTime timeIntervalSinceDate:prevShotTime])];
//        NSLog(@"model.rate: %@", model.rate);
        
    }
//    else {
//        NSLog(@"not enough shot times to determine rate");
//    }
    
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


@end
