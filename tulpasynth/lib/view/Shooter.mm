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

@synthesize lastShotTime;

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
    
    if ([model.rate floatValue] != 0) {
        self.lastShotTime = [NSDate dateWithTimeIntervalSinceNow:0.0f];
        [self shootBall];        
    }
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
    self.lastShotTime = [NSDate dateWithTimeIntervalSinceNow:0.0f];
    
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
    
}

- (void)update {
    [super update];
    
    ShooterModel* model = ((ShooterModel*)self.model);
    
    // if it is time to shoot another ball
    if ([self.lastShotTime timeIntervalSinceNow] < -1.0*[model.rate floatValue]) {
        [self shootBall];
    }
    
}

@end
