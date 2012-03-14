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

@synthesize instr, effect1, glow, rateSlider, rateBeforeSliding, nextShotTime, prevTimeUntilNextShot, animating, nextShotIndex;

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
    
    instr = new instruments::RAMpler();
    NSString* path = [[NSBundle mainBundle] pathForResource:@"NoisePercussionReversed" ofType:@"wav"];
    instr->set_clip([path UTF8String]);
    instr->finish_initializing();
    
//    self.lastShotTime = nil;

    if ([model.rate floatValue] > 0.0f) {
//        self.waitingToShoot = true;
//        instr->play();
//        self.animating = true;
        self.nextShotIndex = model.nextShotIndex;
        self.nextShotTime = [model.shotTimes objectAtIndex:[self.nextShotIndex integerValue]];
        self.prevTimeUntilNextShot = [self.nextShotTime timeIntervalSinceNow];
    }
//    else {
//        self.waitingToShoot = false;
//    }
//    self.animating = false;
    
//    lastPerc = 0.0;
//    prevTimeUntilNextShot = -1.0;
}


- (void) dealloc {
    delete instr;
}


-(void)prepareToDraw {
    float shooterOpacity = 1.0 - self.glow;
    self.effect.useConstantColor = YES;
    GLKVector4 greenColor = self.controller.greenColor;
    self.effect.constantColor = GLKVector4Make(greenColor.r * shooterOpacity, greenColor.g * shooterOpacity, greenColor.b * shooterOpacity, shooterOpacity);
    self.effect.texture2d0.name = self.controller.shooterTexture.name;

    [super prepareToDraw];

}

- (void) postDraw {
    [super postDraw];

    // draw again with second texture.
    GLKVector4 greenColor = self.controller.greenColor;    
    self.effect1.texture2d0.enabled = GL_TRUE;
    self.effect1.texture2d0.envMode = GLKTextureEnvModeModulate;
    self.effect1.texture2d0.target = GLKTextureTarget2D;
    self.effect1.useConstantColor = YES;
    self.effect1.constantColor = GLKVector4Make(greenColor.r * self.glow, greenColor.g * self.glow, greenColor.b * self.glow, self.glow);
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

    
    float velocityScalar = 5.0;
    
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
    if (model.ignoreUpdates) {
        // determine own next shot time
        self.nextShotTime = [NSDate dateWithTimeInterval:(1.0/[model.rate floatValue]) sinceDate:self.nextShotTime];
    }
    else {
        [self advanceToNextShot];
    }
    self.prevTimeUntilNextShot = [self.nextShotTime timeIntervalSinceNow];
}

- (void) advanceToNextShot {
    ShooterModel* model = ((ShooterModel*)self.model);
    float nextIndex = [self.nextShotIndex intValue]+1;
    
    if (nextIndex < [model.shotTimes count]) {
        // assume next shot time will be the next indexed value in the array
        self.nextShotIndex = [NSNumber numberWithInt:nextIndex];
        self.nextShotTime = [model.shotTimes objectAtIndex:[self.nextShotIndex intValue]];
//        NSLog(@"automatically advancing to shot %d", [self.nextShotIndex intValue]);
//        NSLog(@"nextShotTime: %f", [self.nextShotTime timeIntervalSince1970]);        
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    ShooterModel* model = ((ShooterModel*)self.model);
    
//    if ([keyPath isEqualToString:@"nextShotTime"]) {
////        self.nextShotTime = [NSDate dateWithTimeInterval:-1.0*self.controller.socketHandler.timeOffset sinceDate:model.nextShotTime];
//        if (model.nextShotTime != self.nextShotTime) {
//            self.nextShotTime = model.nextShotTime;
//            self.prevTimeUntilNextShot = [model.rate floatValue];
////            self.waitingToShoot = true;
////            self.animating = true;
//        }
//    }
//    // if the rate has changed
//    else if ([keyPath isEqualToString:@"rate"]) {
//        // play loop at same rate
//        instr->freq([model.rate floatValue]);
//        
////        if (model.ignoreUpdates) {
////            // determine own next shot time
////            model.nextShotTime = [NSDate dateWithTimeIntervalSinceNow:(1.0/[model.rate floatValue])];
////        }
//    }
}

- (void)update {
    [super update];
    self.effect1.transform.modelviewMatrix = [self currentModelViewTransform];
    ShooterModel* model = ((ShooterModel*)self.model);
    
    // if it is time to shoot another ball
//    if (self.lastShotTime && self.nextShotTime) {
//        NSLog(@"[self.nextShotTime timeIntervalSinceNow]: %f", [self.nextShotTime timeIntervalSinceNow]);
//    }

//    float currentPerc = instr->percentComplete();
//    float shootPerc = (49572.0/50969.0);
    


    NSTimeInterval timeUntilNextShot = [self.nextShotTime timeIntervalSinceNow];

//    if ([model.rate floatValue] != 0.0) {
//        NSLog(@"nextShotTime: %f", [self.nextShotTime timeIntervalSince1970]);
//        NSLog(@"timeUntilNextShot: %f", timeUntilNextShot);
//        NSLog(@"now: %f", [[NSDate dateWithTimeIntervalSinceNow:0.0] timeIntervalSince1970]);
//    }

    // If it is time to shoot another ball because we're on time
    if (
        timeUntilNextShot < 0 && prevTimeUntilNextShot > 0
        ) {
        //        NSLog(@"shooting");
        
        [self shootBall];
        
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

//    if (self.animating) {
//        // actually shoot ball when sound transient occurs
////        NSLog(@"instr->percentComplete(): %f", instr->percentComplete());
//        if (
//            // current playhead is past shoot marker, and previous playhead was in front
//            (currentPerc > shootPerc && lastPerc < shootPerc)
//            ||
//            // prev playhead was in front, and current playhead has wrapped around
//            (lastPerc < shootPerc && currentPerc < lastPerc)
//        ) {
//            self.animating = false;
//            self.glow = 1.0;
//            [self shootBall];
//            self.waitingToShoot = false;
//        }
//        else {
//            // increase glow
//            self.glow = (instr->percentComplete() / (49572.0/50969.0));
//        }
//    }

//    lastPerc = currentPerc;
    
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

- (void) handleLongPressStarted {
//    NSLog(@"Shooter.handleLongPressStarted");
    ShooterModel* model = ((ShooterModel*)self.model);
    
    model.ignoreUpdates = true;
    
    rateSlider.active = true;
    rateBeforeSliding = model.rate;
}
- (void) handleLongPressUpdated {
    
    ShooterModel* model = ((ShooterModel*)self.model);
    float newRate = [rateBeforeSliding floatValue] + (0.3*self.longPresser->translation.y);
    model.rate = [NSNumber numberWithFloat:newRate];
}
- (void) handleLongPressEnded {
//    NSLog(@"Shooter.handleLongPressEnded");
    ShooterModel* model = ((ShooterModel*)self.model);

    // TODO: synchronization race condition here.  ignoreUpdates should be
    // turned off in callback
    [model synchronize];
    
    model.ignoreUpdates = false;
    rateSlider.active = false;
}


@end
