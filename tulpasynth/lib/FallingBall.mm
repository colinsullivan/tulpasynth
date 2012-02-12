//
//  FallingBall.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FallingBall.h"

static Vertex BallVertices[] = {
    {{1, -1, 0}, {0, 0.5, 0.5}},
    {{1, 1, 0}, {0, 0.5, 0.5}},
    {{-1, 1, 0}, {0, 0.5, 0.5}},
    {{-1, -1, 0}, {0, 0.5, 0.5}}
};


const GLubyte BallIndices[] = {
    0, 1, 2,
    2, 3, 0
};


@implementation FallingBall

- (id)initWithController:(tulpaViewController *)theController withPosition:(b2Vec2)aPosition {

    if (self = [super initWithController:theController withPosition:aPosition]) {
        
        self.width = 10;
        self.height = 10;

        // Create circle shape
        b2CircleShape* myShape = new b2CircleShape();
        myShape->m_radius = self.width/2;
        
        b2FixtureDef myShapeFixture;
        myShapeFixture.shape = myShape;
        myShapeFixture.friction = 0.1f;
        myShapeFixture.density = 0.75f;
        myShapeFixture.restitution = 2.0f;
        
        self.body->CreateFixture(&myShapeFixture);
        
        b2MassData myBodyMass;
        myBodyMass.mass = 0.25f;
        self.body->SetMassData(&myBodyMass);
        
        self.shape = myShape;

        
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(BallVertices), BallVertices, GL_STATIC_DRAW);
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(BallIndices), BallIndices, GL_STATIC_DRAW);        
    }
    return self;
}

- (b2BodyType)bodyType {
    return b2_dynamicBody;
}


//- (void)update {
//    [super update];
//    
    // Calculate new instantaneous position based on current velocity
//    self.position->x *= self.velocity->x;
//    self.position->y += self.velocity->y * self.controller.timeSinceLastUpdate;
    
    // Accelerate
//    self.velocity->y -= 100 * self.controller.timeSinceLastUpdate;
//}

- (void)draw {
    [super draw];
    
    glDrawElements(GL_TRIANGLES, sizeof(BallIndices)/sizeof(BallIndices[0]), GL_UNSIGNED_BYTE, 0);
}


@end
