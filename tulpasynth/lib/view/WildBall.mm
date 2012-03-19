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
    myShapeFixture.friction = 0.1f;
    myShapeFixture.density = 0.75f;
    myShapeFixture.restitution = 1.0f;
    
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
    
    self.color = GLKVector4Make(0, 0.5, 0.5, 1.0);
    self.effect.texture2d0.name = self.controller.glowingCircleTexture.name;

}

- (b2BodyType)bodyType {
    return b2_dynamicBody;
}

- (void) destroy {
    
    // remove shape and body from physics world
    delete ((b2CircleShape*)(self.shape));
    self.body->DestroyFixture(self.shapeFixture);
    
    [super destroy];
}

- (void) update {
    if (self.active) {
        [super update];
    }
}

@end
