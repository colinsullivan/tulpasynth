//
//  ShooterBase.m
//  tulpasynth
//
//  Created by Colin Sullivan on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShooterBase.h"

@implementation ShooterBase

@synthesize instr, glow, nextShotTime, prevTimeUntilNextShot, animating, nextShotIndex, animatingPerc, lastAnimatingPerc, shotTimes, nextPitchIndex;

- (void) setWidth:(float)width {
    [super setWidth:width];
    
    self.shape->m_radius = self.width/2;
}

- (void) initialize {
    [super initialize];
    
    self.longPressable = false;
    self.pincheable = false;
    
    self.glow = 0.0;

    self.nextPitchIndex = [NSNumber numberWithInt:-1];

    ShooterModel* model = ((ShooterModel*)self.model);

    // Create circle shape
    self.shape = new b2CircleShape();
    self.width = [model.width floatValue];
    
    b2FixtureDef myShapeFixture;
    myShapeFixture.shape = self.shape;
    myShapeFixture.friction = 0.1f;
    myShapeFixture.density = 0.75f;
    myShapeFixture.restitution = 1.0f;
    
    self.shapeFixture = self.body->CreateFixture(&myShapeFixture);
    
    b2MassData myBodyMass;
    myBodyMass.mass = 0.25f;
    myBodyMass.center.SetZero();
    self.body->SetMassData(&myBodyMass);

    instr = new instruments::LoopingRAMpler();
    NSString* path = [[NSBundle mainBundle] pathForResource:@"NoisePercussionReversed" ofType:@"wav"];
    instr->set_clip([path UTF8String]);
    ((instruments::Instrument*)(instr))->gain(0.15);
    instr->finish_initializing();

    self.nextShotTime = nil;
    
    self.effect.useConstantColor = YES;
    self.effect1.texture2d0.enabled = GL_TRUE;
    self.effect1.useConstantColor = YES;

}

- (void) dealloc {
    delete instr;
    if (self.shape) {
        delete ((b2CircleShape*)(self.shape));
    }
    
}

-(void)prepareToDraw {
    float shooterOpacity = 1.0 - self.glow;
    GLKVector4 myColor = self.color;
    self.effect.constantColor = GLKVector4Make(myColor.r * shooterOpacity, myColor.g * shooterOpacity, myColor.b * shooterOpacity, shooterOpacity);
    
    [super prepareToDraw];
    
}
- (void)prepareToDraw1 {
    // draw again with second texture.
    GLKVector4 myColor = self.color;
    self.effect1.constantColor = GLKVector4Make(myColor.r * self.glow, myColor.g * self.glow, myColor.b * self.glow, self.glow);
    [super prepareToDraw1];
}

- (b2BodyType)bodyType {
    return b2_staticBody;
}

- (void) shootBall {
    ShooterModel* model = ((ShooterModel*)self.model);
    
    
    float velocityScalar = 7.0;
    
    float wildBallWidth = [[[WildBallModel defaultAttributes] valueForKey:@"width"] floatValue];
    
    // Create wild ball
    WildBallModel* m = [[WildBallModel alloc] initWithController:self.controller withAttributes:
                        [NSMutableDictionary dictionaryWithKeysAndObjects:
                         @"initialPosition", [NSDictionary dictionaryWithKeysAndObjects:
                                              @"x", [NSNumber numberWithFloat:
                                                     self.position->x
                                                     +
                                                     cosf(self.angle)*(self.width/2.0 + 1)
                                                     +
                                                     cosf(self.angle)*(wildBallWidth/2.0)
                                                     ],
                                              @"y", [NSNumber numberWithFloat:
                                                     self.position->y
                                                     +
                                                     -sinf(self.angle)*(self.height/2.0)
                                                     +
                                                     -sinf(self.angle)*(wildBallWidth/2.0)
                                                     ]
                                              , nil],
                         @"initialLinearVelocity", [NSDictionary dictionaryWithKeysAndObjects:
                                                    @"x", [NSNumber numberWithFloat:cosf(self.angle)*velocityScalar],
                                                    @"y", [NSNumber numberWithFloat:-sinf(self.angle)*velocityScalar],
                                                    nil],
                         @"pitchIndex", self.nextPitchIndex,
                         nil]];
    
    [self advanceToNextShot];
}

- (BOOL) advanceToNextShot {
    // if we still need to shoot our current ball
    if (self.nextShotTime && [self.nextShotTime timeIntervalSinceNow] > 0) {
        // wait.
        return false;
    }
    else {
        return true;
    }
}

- (void) startAnimating {
    self.animating = true;
    self.animatingPerc = 0.0;
    self.lastAnimatingPerc = 0.0;
    instr->reset();
    instr->play();
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    ShooterModel* model = ((ShooterModel*)self.model);

    
    // if model was destroyed
    if ([keyPath isEqualToString:@"destroyed"]) {
        instr->stop();
        instr->reset();
    }

}

- (void) update {
    [super update];

    if (!self.active) {
        return;
    }
    
    //    if ([model.rate floatValue] != 0.0) {
    //        NSLog(@"nextShotTime: %f", [self.nextShotTime timeIntervalSince1970]);
    //        NSLog(@"timeUntilNextShot: %f", timeUntilNextShot);
    //        NSLog(@"now: %f", [[NSDate dateWithTimeIntervalSinceNow:0.0] timeIntervalSince1970]);
    //    }
    
    ShooterModel* model = ((ShooterModel*)self.model);
    
    self.animatingPerc = instr->percentComplete();
    float shootPerc = (49572.0/50969.0);

    // actually shoot ball when sound transient occurs
    //        NSLog(@"instr->percentComplete(): %f", instr->percentComplete());
    if (
        // current playhead is past shoot marker, and previous playhead was in front
        (animatingPerc > shootPerc && lastAnimatingPerc < shootPerc)
        ||
        // prev playhead was in front, and current playhead has wrapped around
        (lastAnimatingPerc < shootPerc && animatingPerc < lastAnimatingPerc)
        ) {
        //        self.animating = false;
        self.glow = 1.0;
        [self shootBall];
    }
    else {
        // increase glow
        self.glow = (instr->percentComplete() / shootPerc);
    }
    
    lastAnimatingPerc = animatingPerc;
    
    // if there is another ball to shoot
    if (self.nextShotTime) {
        NSTimeInterval timeUntilNextShot = [self.nextShotTime timeIntervalSinceNow];
//        NSLog(@"timeUntilNextShot: %f", timeUntilNextShot);
        // If it is time to shoot another ball because we're on time
        if (
            timeUntilNextShot <= 0 && prevTimeUntilNextShot > 0
            ) {
//        NSLog(@"shooting");
            
            [self startAnimating];
            
            //        instr->freq([model.rate floatValue]);
            //        instr->reset();
        }
        // if we're behind schedule
        else if (timeUntilNextShot < 0 && prevTimeUntilNextShot < 0) {
//            NSLog(@"advancing");
            // advance without shooting ball
            [self advanceToNextShot];
        }
        //    // if we've run out of shoots
        //    else if ([self.nextShotIndex integerValue] == [model.shotTimes count]-1) {
        ////        NSLog(@"No 'mo shoots!");
        //    }
        prevTimeUntilNextShot = timeUntilNextShot;
    }


}


@end
