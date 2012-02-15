//
//  Square.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Square.h"

static Vertex SquareVertices[] = {
    {{1, -1, 0}, {0.15, 0.88, 0.49, 1.0}, {1, 0}},
    {{1, 1, 0}, {0.15, 0.88, 0.49, 1.0}, {1, 1}},
    {{-1, 1, 0}, {0.15, 0.88, 0.49, 1.0}, {0, 1}},
    {{-1, -1, 0}, {0.15, 0.88, 0.49, 1.0}, {0, 0}}
};


const GLubyte SquareIndices[] = {
    0, 1, 2,
    2, 3, 0
};

@implementation Square

@synthesize instr;

/**
 *  When width or height is set, change shape.
 **/
- (void)setWidth:(float32)aWidth withHeight:(float32)aHeight {
    self.width = aWidth;
    self.height = aHeight;

    if (self.shapeFixture) {
        self.body->DestroyFixture(self.shapeFixture);        
    }
    
    if (self.shape) {
        delete self.shape;
    }
    
    self.shape = new b2PolygonShape();
    self.shape->m_radius = 1.0f;
    ((b2PolygonShape*)self.shape)->SetAsBox(self.width/2 - (self.width/15), self.height/2 - (self.height/15));
    
    b2FixtureDef mySquareFixture;
    mySquareFixture.shape = self.shape;
    mySquareFixture.density = 1.0f;
    mySquareFixture.friction = 0.1f;
    mySquareFixture.restitution = 0.75f;
    
    self.shapeFixture = self.body->CreateFixture(&mySquareFixture);
}

- (id)initWithController:(tulpaViewController *)theController withPosition:(b2Vec2)aPosition {
    
    if (self = [super initWithController:theController withPosition:aPosition]) {

        [self setWidth:50 withHeight:20];
                
        b2MassData myBodyMass;
        myBodyMass.mass = 10.0f;
        self.body->SetMassData(&myBodyMass);
        
        self.instr = new instruments::FMPercussion();
        
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(SquareVertices), SquareVertices, GL_STATIC_DRAW);
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(SquareIndices), SquareIndices, GL_STATIC_DRAW);        
    }

    return self;
}

-(void)prepareToDraw {
    self.effect.texture2d0.enabled = GL_TRUE;
    self.effect.texture2d0.envMode = GLKTextureEnvModeModulate;
    self.effect.texture2d0.target = GLKTextureTarget2D;
    self.effect.texture2d0.name = self.controller.glowingBoxTexture.name;
    
    [super prepareToDraw];
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
}

- (void)draw {
    [super draw];

    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, TexCoord));

    glDrawElements(GL_TRIANGLES, sizeof(SquareIndices)/sizeof(SquareIndices[0]), GL_UNSIGNED_BYTE, 0);
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
