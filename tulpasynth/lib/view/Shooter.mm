/**
 *  @file       Shooter.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "Shooter.h"

#import "tulpaViewController.h"

@implementation Shooter

@synthesize rateSlider;



- (void) initialize {
    [super initialize];
    ShooterModel* model = ((ShooterModel*)self.model);

    instruments::LoopingRAMpler* theInstr = new instruments::LoopingRAMpler();
    NSString* path = [[NSBundle mainBundle] pathForResource:@"NoisePercussionReversed" ofType:@"wav"];
    theInstr->set_clip([path UTF8String]);
    ((instruments::Instrument*)(theInstr))->gain(0.15);
    theInstr->finish_initializing();
    self.instr = ((instruments::Instrument*)theInstr);

    // create rate slider which is initially hidden by default
    rateSlider = [[ShooterRateSlider alloc] initWithController:self.controller withModel:model];
    
    self.shotTimes = [NSMutableArray arrayWithArray:model.shotTimes];
    self.nextShotIndex = [NSNumber numberWithInt:-1];
    [self advanceToNextShot];

    self.effect.texture2d0.name = self.controller.shooterTexture.name;
    self.effect1.texture2d0.name = self.controller.shooterGlowingTexture.name;
}

- (void) dealloc {
    delete ((instruments::LoopingRAMpler*)self.instr);
}



- (void) postDraw {
    [super postDraw];
    
    // draw rate slider
    [rateSlider prepareToDraw];
    [rateSlider draw];
    [rateSlider postDraw];
}



- (BOOL) advanceToNextShot {
    
    if ([super advanceToNextShot]) {
        ShooterModel* model = ((ShooterModel*)self.model);
        int nextIndex = [self.nextShotIndex intValue]+1;
        
        //    NSLog(@"now: %@", [NSDate dateWithTimeIntervalSinceNow:0.0]);
        
        if (nextIndex < [model.shotTimes count]) {
            // assume next shot time will be the next indexed value in the array
            self.nextShotIndex = [NSNumber numberWithInt:nextIndex];
            //        NSLog(@"automatically advancing to shot %d", [self.nextShotIndex intValue]);
            self.nextShotTime = [model.shotTimes objectAtIndex:[self.nextShotIndex intValue]];
            //        NSLog(@"nextShotTime: %@", self.nextShotTime);        
            self.prevTimeUntilNextShot = [self.nextShotTime timeIntervalSinceNow];
            
            //        if ([self.nextShotTime timeIntervalSinceNow] > 0.0) {
            //            [self advanceToNextShot];
            //        }
            return true;
        }
        // no more shots
        else {
//            NSLog(@"no mo");
            self.instr->stop();
            self.nextShotTime = nil;
            return false;
        }  
    }

    return false;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    ShooterModel* model = ((ShooterModel*)self.model);
    
    if ([keyPath isEqualToString:@"shotTimes"]) {
        
        if ([model.shotTimes count] == 0) {
            return;
        }
        
//        NSLog(@"shotTimes changed");
//        NSLog(@"[shotTimes count]: %d", [model.shotTimes count]);
//        if ([model.rate floatValue] > 0.0) {

//        self.shotTimes = [NSMutableArray arrayWithArray:model.shotTimes];
        
        if (model.shotTimes != self.shotTimes) {
//            NSLog(@"resetting shot times");
            self.nextShotIndex = [NSNumber numberWithInt:0];
            self.shotTimes = model.shotTimes;
            self.nextShotTime = [model.shotTimes objectAtIndex:0];
            self.prevTimeUntilNextShot = [self.nextShotTime timeIntervalSinceNow];
        }

        
        // try advancing
        [self advanceToNextShot];            
    }
    // if the rate has changed
    else if ([keyPath isEqualToString:@"rate"]) {
        // play loop at same rate
        self.instr->freq([model.rate floatValue]);            
        //        
        ////        if (model.ignoreUpdates) {
        ////            // determine own next shot time
        ////            model.nextShotTime = [NSDate dateWithTimeIntervalSinceNow:(1.0/[model.rate floatValue])];
        ////        }
    }

}


- (void)update {
    [super update];

    [rateSlider update];
}

- (void) setSelected:(BOOL)wasSelected {
    [super setSelected:wasSelected];
    if (wasSelected) {
        rateSlider.active = true;
    }
    else {
        rateSlider.active = false;
    }
}

- (GLboolean) handlePan:(PanEntity *)pan {
    // if user wasn't trying to move object
    if (![super handlePan:pan]) {
        // if we're selected
        if (self.selected) {
            // may have been trying to change rate slider
            if ([rateSlider handlePan:pan]) {
                return true;
            }
        }        
    }
    else {
        return true;
    }
    return false;
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
