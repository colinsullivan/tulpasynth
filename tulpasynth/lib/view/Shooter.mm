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

static Vertex ShooterVertices[] = {
    {{1, -1, 0}, {0.15, 0.88, 0.49, 1.0}, {1, 0}},
    {{1, 1, 0}, {0.15, 0.88, 0.49, 1.0}, {1, 1}},
    {{-1, 1, 0}, {0.15, 0.88, 0.49, 1.0}, {0, 1}},
    {{-1, -1, 0}, {0.15, 0.88, 0.49, 1.0}, {0, 0}}
};


const GLubyte ShooterIndices[] = {
    0, 1, 2,
    2, 3, 0
};

@implementation Shooter


- (void) initialize {
    
    [super initialize];

    b2MassData myBodyMass;
    myBodyMass.mass = 10.0f;
    self.body->SetMassData(&myBodyMass);
    
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(ShooterVertices), ShooterVertices, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(ShooterIndices), ShooterIndices, GL_STATIC_DRAW);
}

- (void) dealloc {

    
    [super dealloc];
}

-(void)prepareToDraw {
    self.effect.texture2d0.enabled = GL_TRUE;
    self.effect.texture2d0.envMode = GLKTextureEnvModeModulate;
    self.effect.texture2d0.target = GLKTextureTarget2D;
    self.effect.texture2d0.name = self.controller.shooterTexture.name;
    
    [super prepareToDraw];
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
}

- (void)draw {
    [super draw];

    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, TexCoord));

    glDrawElements(GL_TRIANGLES, sizeof(ShooterIndices)/sizeof(ShooterIndices[0]), GL_UNSIGNED_BYTE, 0);
}

- (void)postDraw {
    [super postDraw];
    
    glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
}

//- (void)update {
//    [super update];
//
//}

@end
