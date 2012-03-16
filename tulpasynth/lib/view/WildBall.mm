//
//  WildBall.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WildBall.h"

#import "tulpaViewController.h"

@implementation WildBall

- (void) setWidth:(float)width {
    [super setWidth:width];
    
    self.shape->m_radius = self.width/2;
}

- (void) initialize {
    [super initialize];
    
    WildBallModel* model = ((WildBallModel*)self.model);
    
    // Create circle shape
    self.shape = new b2CircleShape();
    self.width = [model.width floatValue];
    
    b2FixtureDef myShapeFixture;
    myShapeFixture.shape = self.shape;
    myShapeFixture.friction = 0.0f;
    myShapeFixture.density = 0.75f;
    myShapeFixture.restitution = 0.0f;
    
    self.shapeFixture = self.body->CreateFixture(&myShapeFixture);
    
    b2MassData myBodyMass;
    myBodyMass.mass = 2.00f;
    myBodyMass.center.SetZero();
    self.body->SetMassData(&myBodyMass);
    
    self.body->SetLinearVelocity(
                                 b2Vec2(
                                        [[model.initialLinearVelocity valueForKey:@"x"] floatValue], 
                                        [[model.initialLinearVelocity valueForKey:@"y"] floatValue]
                                        )
                                 );

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
