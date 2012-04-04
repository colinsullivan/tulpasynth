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

@synthesize nextShotRate;

- (void) initialize {
    [super initialize];
    self.effect.texture2d0.name = self.controller.receivingShooterTexture.name;
    self.effect1.texture2d0.name = self.controller.receivingShooterGlowingTexture.name;
    
    self.nextShotRate = nil;
    
}
- (void) startAnimating {
    
    self.instr->freq([self.nextShotRate floatValue]);
    
    [super startAnimating];
    
}

- (BOOL) advanceToNextShot {
    if ([super advanceToNextShot]) {
        int nextIndex;

        ReceivingShooterModel* model = ((ReceivingShooterModel*)self.model);

        // if we haven't shot a ball yet, and we have more than one shot queued
        if (!self.nextShotTime && [self.shotTimes count] > 1) {
            nextIndex = 0;
        }
        else if (self.nextShotTime) {
            nextIndex = [self.nextShotIndex intValue]+1;
        }
        // we haven't shot a ball yet and there aren't enough shots queued.
        else {
            return false;
        }

        
        if (nextIndex+1 < [self.shotTimes count]) {
            NSDate* newNextShotTime = [self.shotTimes objectAtIndex:nextIndex];

            // determine rate based on next next shot time
            NSDate* futureShotTime = [self.shotTimes objectAtIndex:nextIndex+1];
//            NSLog(@"futureShotTime: %f", [futureShotTime timeIntervalSince1970]);
//            NSLog(@"nextShotTime: %f", [newNextShotTime timeIntervalSince1970]);
//            NSLog(@"now: %f", [[NSDate dateWithTimeIntervalSinceNow:0.0] timeIntervalSince1970]);
            NSTimeInterval nextToFuture = [futureShotTime timeIntervalSinceDate:newNextShotTime];
//            NSLog(@"nextToFuture: %f", nextToFuture);
            self.nextShotRate = [NSNumber numberWithDouble:(1.0 / nextToFuture)];
            
            if (nextIndex < [model.nextPitchIndexes count]) {
                self.nextPitchIndex = [model.nextPitchIndexes objectAtIndex:nextIndex];
            }

            // setting nextShotTime allows the update method to shoot a ball
            self.nextShotIndex = [NSNumber numberWithInt:nextIndex];
            self.nextShotTime = newNextShotTime;
            self.prevTimeUntilNextShot = [self.nextShotTime timeIntervalSinceNow];
//            NSLog(@"self.prevTimeUntilNextShot: %f", self.prevTimeUntilNextShot);

            return true;
        }
        else {
//            NSLog(@"no mo shots received");
//            self.instr->stop();
            return false;
        }
    }
    
    return false;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    ReceivingShooterModel* model = ((ReceivingShooterModel*)self.model);
    
    if ([keyPath isEqualToString:@"shotTimes"]) {
        
        if ([model.shotTimes count] == 0) {
            return;
        }
        else {
            self.shotTimes = model.shotTimes;
//            NSLog(@"self.shotTimes: %@", self.shotTimes);
            [self advanceToNextShot];
        }
        
//        NSLog(@"shotTimes changed");
//        NSLog(@"[shotTimes count]: %d", [model.shotTimes count]);
        //        if ([model.rate floatValue] > 0.0) {
        
        //        self.shotTimes = [NSMutableArray arrayWithArray:model.shotTimes];

        
//        if (model.shotTimes != self.shotTimes) {
//            NSLog(@"resetting shot times");
//            self.shotTimes = model.shotTimes;
//        }
        
        
        // try advancing
//        [self advanceToNextShot];            
    }
}

+ (GLKBaseEffect*)effectInstance {
    static GLKBaseEffect* theInstance = nil;
    if (!theInstance) {
        theInstance = [[GLKBaseEffect alloc] init];
    }
    return theInstance;
}

+ (GLKBaseEffect*)effect1Instance {
    static GLKBaseEffect* theInstance = nil;
    if (!theInstance) {
        theInstance = [[GLKBaseEffect alloc] init];
    }
    return theInstance;
}


@end
