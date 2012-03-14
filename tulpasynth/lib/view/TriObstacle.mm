//
//  TriObstacle.m
//  tulpasynth
//
//  Created by Colin Sullivan on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TriObstacle.h"

#import "tulpaViewController.h"
@implementation TriObstacle


- (void)createShape {
    if (!self.width || !self.height) {
        return;
    }

    [super createShape];
    
    self.shape->m_radius = 0.5f;

    b2Vec2 triVertices[3];
    triVertices[0].Set(-self.width/2.0, -self.height/2.0);
    triVertices[1].Set(self.width/2.0, -self.height/2.0);
    triVertices[2].Set(0.0, self.height/2.0);

    ((b2PolygonShape*)self.shape)->Set(triVertices, 3);
    
    b2FixtureDef mySquareFixture;
    mySquareFixture.shape = self.shape;
    mySquareFixture.density = 1.0f;
    mySquareFixture.friction = 0.1f;
    mySquareFixture.restitution = 1.5f;
    
    self.shapeFixture = self.body->CreateFixture(&mySquareFixture);
}


- (void) initialize {
    [super initialize];
    
    b2MassData myBodyMass;
    myBodyMass.mass = 10.0f;
    self.body->SetMassData(&myBodyMass);
    
    self.effect.useConstantColor = YES;
    self.effect.constantColor = self.controller.greenColor;
    self.effect.texture2d0.name = self.controller.triObstacleTexture.name;
}

@end
