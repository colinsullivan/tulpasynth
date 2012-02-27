/**
 *  @file       FallingBall.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "FallingBall.h"

#import "tulpaViewController.h"

@implementation FallingBall

- (void) setWidth:(float)width {
    [super setWidth:width];
    
    self.shape->m_radius = self.width/2;
}

- (void) initialize {
    [super initialize];
    
    FallingBallModel* model = ((FallingBallModel*)self.model);
    
    // Create circle shape
    self.shape = new b2CircleShape();
    self.shape->m_radius = [model.width floatValue]/2.0;
    
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
}

- (b2BodyType)bodyType {
    return b2_dynamicBody;
}


-(void)prepareToDraw {
    self.effect.useConstantColor = YES;
    self.effect.constantColor = GLKVector4Make(0, 0.5, 0.5, 1.0);
    self.effect.texture2d0.name = self.controller.glowingCircleTexture.name;

    [super prepareToDraw];
    
}


@end
