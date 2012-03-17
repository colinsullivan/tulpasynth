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

@synthesize instr, effect1, glow, rateSlider, nextShotTime, prevTimeUntilNextShot, animating, nextShotIndex, animatingPerc, lastAnimatingPerc, shotTimes;

- (void) setWidth:(float)width {
    [super setWidth:width];
    
    self.shape->m_radius = self.width/2;
}


- (void) initialize {
    
    [super initialize];
    
    self.longPressable = true;
    
    self.effect1 = [[GLKBaseEffect alloc] init];
    self.effect1.transform.projectionMatrix = GLKMatrix4MakeOrtho(
                                                                 0,
                                                                 self.controller.view.frame.size.width,
                                                                 self.controller.view.frame.size.height,
                                                                 0,
                                                                 -1,
                                                                 1);
    self.glow = 0.0;
        
    ShooterModel* model = ((ShooterModel*)self.model);

    // create rate slider which is initially hidden by default
    rateSlider = [[ShooterRateSlider alloc] initWithController:self.controller withModel:model];

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
    instr->finish_initializing();
    
//    self.lastShotTime = nil;

    if ([model.rate floatValue] > 0.0f) {
        self.shotTimes = [NSMutableArray arrayWithArray:model.shotTimes];
        self.nextShotIndex = [NSNumber numberWithInt:-1];
        [self advanceToNextShot];
//        self.waitingToShoot = true;
//        instr->play();
//        self.animating = true;
    }
//    else {
//        self.waitingToShoot = false;
//    }
//    self.animating = false;
    
//    lastPerc = 0.0;
//    prevTimeUntilNextShot = -1.0;
    
    self.effect.texture2d0.name = self.controller.shooterTexture.name;
    self.effect.useConstantColor = YES;

}


- (void) dealloc {
    delete instr;
}


-(void)prepareToDraw {
    float shooterOpacity = 1.0 - self.glow;
    GLKVector4 myColor = self.color;
    self.effect.constantColor = GLKVector4Make(myColor.r * shooterOpacity, myColor.g * shooterOpacity, myColor.b * shooterOpacity, shooterOpacity);

    [super prepareToDraw];

}

- (void) postDraw {
    [super postDraw];

    // draw again with second texture.
    GLKVector4 myColor = self.color;
    self.effect1.texture2d0.enabled = GL_TRUE;
    self.effect1.texture2d0.envMode = GLKTextureEnvModeModulate;
    self.effect1.texture2d0.target = GLKTextureTarget2D;
    self.effect1.useConstantColor = YES;
    self.effect1.constantColor = GLKVector4Make(myColor.r * self.glow, myColor.g * self.glow, myColor.b * self.glow, self.glow);
    self.effect1.texture2d0.name = self.controller.shooterGlowingTexture.name;
    
    [self.effect1 prepareToDraw];

    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //    glEnableVertexAttribArray(GLKVertexAttribColor);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    [super draw];
    [super postDraw];

    // draw rate slider
    [rateSlider prepareToDraw];
    [rateSlider draw];
    [rateSlider postDraw];
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
                         nil]];
    
//    self.lastShotTime = model.nextShotTime;
//    if (model.ignoreUpdates) {
//        // determine own next shot time
//        self.nextShotTime = [NSDate dateWithTimeInterval:(1.0/[model.rate floatValue]) sinceDate:self.nextShotTime];
//        self.prevTimeUntilNextShot = [self.nextShotTime timeIntervalSinceNow];
//    }
//    else {
        [self advanceToNextShot];
//    }
}

- (void) advanceToNextShot {
    ShooterModel* model = ((ShooterModel*)self.model);
    float nextIndex = [self.nextShotIndex intValue]+1;
    
    if (nextIndex < [model.shotTimes count]) {
        // assume next shot time will be the next indexed value in the array
        self.nextShotIndex = [NSNumber numberWithInt:nextIndex];
//        NSLog(@"automatically advancing to shot %d", [self.nextShotIndex intValue]);
        self.nextShotTime = [model.shotTimes objectAtIndex:[self.nextShotIndex intValue]];
        self.prevTimeUntilNextShot = [self.nextShotTime timeIntervalSinceNow];
//        NSLog(@"nextShotTime: %f", [self.nextShotTime timeIntervalSince1970]);        
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    ShooterModel* model = ((ShooterModel*)self.model);
    
    if ([keyPath isEqualToString:@"shotTimes"]) {
//        NSLog(@"shotTimes changed");
        if ([model.rate floatValue] > 0.0) {
            // if new shot times array is not greater, we should reset index
            if ([model.shotTimes count] <= [self.shotTimes count]) {
                self.shotTimes = [NSMutableArray arrayWithArray:model.shotTimes];
                self.nextShotIndex = [NSNumber numberWithInt:-1];
                [self advanceToNextShot];
            }
            else {
                self.shotTimes = [NSMutableArray arrayWithArray:model.shotTimes];
            }
        }
//        self.nextShotIndex = model.nextShotIndex;
//        self.nextShotTime = [model.shotTimes objectAtIndex:[self.nextShotIndex intValue]];
//        self.prevTimeUntilNextShot = [self.nextShotTime timeIntervalSinceNow];
    }
    
//    if ([keyPath isEqualToString:@"nextShotTime"]) {
////        self.nextShotTime = [NSDate dateWithTimeInterval:-1.0*self.controller.socketHandler.timeOffset sinceDate:model.nextShotTime];
//        if (model.nextShotTime != self.nextShotTime) {
//            self.nextShotTime = model.nextShotTime;
//            self.prevTimeUntilNextShot = [model.rate floatValue];
////            self.waitingToShoot = true;
////            self.animating = true;
//        }
//    }
    // if the rate has changed
    else if ([keyPath isEqualToString:@"rate"]) {
        // play loop at same rate
        instr->freq([model.rate floatValue]);
//        
////        if (model.ignoreUpdates) {
////            // determine own next shot time
////            model.nextShotTime = [NSDate dateWithTimeIntervalSinceNow:(1.0/[model.rate floatValue])];
////        }
    }
}

- (void) startAnimating {
    self.animating = true;
    self.animatingPerc = 0.0;
    self.lastAnimatingPerc = 0.0;
    instr->reset();
    instr->play();
}

- (void)update {
    [super update];
    self.effect1.transform.modelviewMatrix = [self currentModelViewTransform];
    ShooterModel* model = ((ShooterModel*)self.model);
    
    // if it is time to shoot another ball
//    if (self.lastShotTime && self.nextShotTime) {
//        NSLog(@"[self.nextShotTime timeIntervalSinceNow]: %f", [self.nextShotTime timeIntervalSinceNow]);
//    }


    NSTimeInterval timeUntilNextShot = [self.nextShotTime timeIntervalSinceNow];

//    if ([model.rate floatValue] != 0.0) {
//        NSLog(@"nextShotTime: %f", [self.nextShotTime timeIntervalSince1970]);
//        NSLog(@"timeUntilNextShot: %f", timeUntilNextShot);
//        NSLog(@"now: %f", [[NSDate dateWithTimeIntervalSinceNow:0.0] timeIntervalSince1970]);
//    }


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


    // If it is time to shoot another ball because we're on time
    if (
        timeUntilNextShot < 0 && prevTimeUntilNextShot > 0
        ) {
//        NSLog(@"shooting");
        
        [self startAnimating];
        
        //        instr->freq([model.rate floatValue]);
//        instr->reset();
    }
    // if we're behind schedule
    else if (timeUntilNextShot < 0 && prevTimeUntilNextShot < 0 && [self.nextShotIndex integerValue] < [model.shotTimes count]) {
        [self advanceToNextShot];
    }
    // if we've run out of shoots
    else if ([self.nextShotIndex integerValue] == [model.shotTimes count]-1) {
//        NSLog(@"No 'mo shoots!");
    }
    prevTimeUntilNextShot = timeUntilNextShot;

    
//    // if it is time to trigger shooting sound
//    // (transient is at 01.12 seconds into file)
//    stk::StkFloat transientPoint = 49572;
//    unsigned long sampleDuration = instr->duration();
//    // if duration is longer than the time we have to wait
//    if (sampleDuration > -1.0*[self.nextShotTime timeIntervalSinceNow]) {
//        // we must start
//    }
    
    // play 1.25 seconds before shoot time
//    if ([self.lastShotTime timeIntervalSinceNow] < -1.0*[model.rate floatValue]) {
//    }
    
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
    // if user wasn't trying to move object and we're selected
    if (![super handlePan:pan] && self.selected) {
        // may have been trying to change rate slider
        if ([rateSlider handlePan:pan]) {
            return true;
        }
    }
    
    return false;
}


- (void) handleLongPressStarted {
//    NSLog(@"Shooter.handleLongPressStarted");
    ShooterModel* model = ((ShooterModel*)self.model);

    
    rateSlider.active = true;
}
- (void) handleLongPressUpdated {
    
}
- (void) handleLongPressEnded {
//    NSLog(@"Shooter.handleLongPressEnded");
    ShooterModel* model = ((ShooterModel*)self.model);
    
    

}


@end
