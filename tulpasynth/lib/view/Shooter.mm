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

@synthesize lastShotTime, nextShotTime, instr;

- (void) setWidth:(float)width {
    [super setWidth:width];
    
    self.shape->m_radius = self.width/2;
}


- (void) initialize {
    
    [super initialize];    
    ShooterModel* model = ((ShooterModel*)self.model);
    
    // Create circle shape
    self.shape = new b2CircleShape();
    self.width = [model.width floatValue];
    
    b2FixtureDef myShapeFixture;
    myShapeFixture.shape = self.shape;
    myShapeFixture.friction = 0.1f;
    myShapeFixture.density = 0.75f;
    myShapeFixture.restitution = 2.0f;
    
    self.shapeFixture = self.body->CreateFixture(&myShapeFixture);
    
    b2MassData myBodyMass;
    myBodyMass.mass = 0.25f;
    myBodyMass.center.SetZero();
    self.body->SetMassData(&myBodyMass);
    
    instr = new instruments::RAMpler();
    NSString* path = [[NSBundle mainBundle] pathForResource:@"NoisePercussionReversed" ofType:@"wav"];
    instr->set_clip([path UTF8String]);
    
    if ([model.rate floatValue] > 0.0f) {
        self.lastShotTime = nil;
        self.nextShotTime = [NSDate dateWithTimeIntervalSinceNow:[model.rate floatValue]];        
    }
}

- (void) dealloc {
    delete instr;
}


-(void)prepareToDraw {
    self.effect.useConstantColor = YES;
    self.effect.constantColor = GLKVector4Make(0.15, 0.88, 0.49, 1.0);
    self.effect.texture2d0.name = self.controller.shooterTexture.name;
    
    [super prepareToDraw];
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
    
    WildBall* b = [[WildBall alloc] initWithController:self.controller withModel:m];
    
    [self.controller.wildBalls addObject:b];
    
    self.lastShotTime = [NSDate dateWithTimeIntervalSinceNow:0.0f];
    self.nextShotTime = [NSDate dateWithTimeIntervalSinceNow:[model.rate floatValue]];
}

- (void)update {
    [super update];
        
    // if it is time to shoot another ball
//    if (self.lastShotTime && self.nextShotTime) {
//        NSLog(@"[self.nextShotTime timeIntervalSinceNow]: %f", [self.nextShotTime timeIntervalSinceNow]);
//    }
    
    // If it is time to shoot another ball
    if ([self.nextShotTime timeIntervalSinceNow] < 0) {
        // start playing sound
        instr->play();
    }

    // actually shoot ball when sound transient occurs
    if (instr->percentComplete() > (49572.0/50969.0)) {        
        [self shootBall];
    }
    
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
    
}

@end
