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

static Vertex BallVertices[] = {
    {{1, -1, 0}, {0, 0.5, 0.5, 1.0}, {1, 0}},
    {{1, 1, 0}, {0, 0.5, 0.5, 1.0}, {1, 1}},
    {{-1, 1, 0}, {0, 0.5, 0.5, 1.0}, {0, 1}},
    {{-1, -1, 0}, {0, 0.5, 0.5, 1.0}, {0, 0}}
};


const GLubyte BallIndices[] = {
    0, 1, 2,
    2, 3, 0
};

@implementation FallingBall

- (void) setWidth:(float)width {
    [super setWidth:width];
    
    self.shape->m_radius = self.width/2;
}

- (void) initialize {
    [super initialize];
    
    // Create circle shape
    self.shape = new b2CircleShape();
    
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
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(BallVertices), BallVertices, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(BallIndices), BallIndices, GL_STATIC_DRAW);
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

-(void)prepareToDraw {
    self.effect.texture2d0.enabled = GL_TRUE;
    self.effect.texture2d0.envMode = GLKTextureEnvModeModulate;
    self.effect.texture2d0.target = GLKTextureTarget2D;
    self.effect.texture2d0.name = self.controller.glowingCircleTexture.name;

    [super prepareToDraw];

    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
}

- (void)draw {    
    [super draw];

    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, TexCoord));

//    glVertexAttribPointer(self.controller._texCoordSlot, 2, GL_FLOAT, GL_FALSE, 
//                          sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));     
//    glActiveTexture(GL_TEXTURE0); 
//    glBindTexture(GL_TEXTURE_2D, self.controller.glowingCircleTexture);
//    glUniform1i(self.controller._textureUniform, 0);
    glDrawElements(GL_TRIANGLES, sizeof(BallIndices)/sizeof(BallIndices[0]), GL_UNSIGNED_BYTE, 0);
    
}

- (void)postDraw {
    [super postDraw];

    glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
}


@end
