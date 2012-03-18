//
//  GLView.mm
//  tulpasynth
//
//  Created by Colin Sullivan on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GLView.h"
#import "tulpaViewController.h"


// Texture coordinates are rotated -90 degrees and flipped vertically because
// this app only works in landscape.  I know, how budget.
static Vertex SquareVertices[] = {
    {{1, -1, 0}, {0.0, 0.0, 0.0, 1.0}, {0, 1}},
    {{1, 1, 0}, {0.0, 0.0, 0.0, 1.0}, {1, 1}},
    {{-1, 1, 0}, {0.0, 0.0, 0.0, 1.0}, {1, 0}},
    {{-1, -1, 0}, {0.0, 0.0, 0.0, 1.0}, {0, 0}}
};


static GLubyte SquareIndices[] = {
    0, 1, 2,
    2, 3, 0
};

@implementation GLView

@synthesize position, width, height, angle;

@synthesize active;

@synthesize effect;

@synthesize panner;

/**
 *  Since position is a reference to a C++ object, override to avoid memory leaks
 **/
- (b2Vec2*)position {
    if (!position) {
        position = new b2Vec2(0, 0);
    }
    
    return position;
}

/**
 *  Ensure angle is between 0 and 2PI
 **/
- (void) setAngle:(float32)anAngle {
    while (anAngle >= M_PI*2) {
        anAngle -= M_PI*2;
    }
    angle = anAngle;
}

- (void) initialize {
    
    [super initialize];
    
    // Shader for this object
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(
                                                                 0,
                                                                 self.controller.view.frame.size.width,
                                                                 self.controller.view.frame.size.height,
                                                                 0,
                                                                 -1,
                                                                 1);

    // Vertex buffers
    glGenBuffers(1, &_vertexBuffer);        
    glGenBuffers(1, &_indexBuffer);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
//    glBufferData(GL_ARRAY_BUFFER, sizeof(_vertices), _vertices, GL_DYNAMIC_DRAW);
    glBufferData(GL_ARRAY_BUFFER, sizeof(SquareVertices), SquareVertices, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
//    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof([self indices]), [self indices], GL_STATIC_DRAW);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(SquareIndices), SquareIndices, GL_DYNAMIC_DRAW);

    self.effect.texture2d0.enabled = GL_TRUE;
    self.effect.texture2d0.envMode = GLKTextureEnvModeModulate;
    self.effect.texture2d0.target = GLKTextureTarget2D;
    
    self.panner = nil;

    [[GLView Instances] addObject:self];
}

- (Vertex*)vertices {
    return NULL;
}
- (GLubyte*)indices {
    return NULL;
}

- (void)prepareToDraw {
    [self.effect prepareToDraw];
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
//    glEnableVertexAttribArray(GLKVertexAttribColor);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
}

- (void)draw {
    
    if (self.active) {
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));
        //    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Color));    
        
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, TexCoord));
        
        //    glDrawElements(GL_TRIANGLES, sizeof([self indices])/sizeof([self indices][0]), GL_UNSIGNED_BYTE, 0);
        glDrawElements(GL_TRIANGLES, sizeof(SquareIndices)/sizeof(SquareIndices[0]), GL_UNSIGNED_BYTE, 0);        
    }
}

- (void)postDraw {
    glDisableVertexAttribArray(GLKVertexAttribPosition);
//    glDisableVertexAttribArray(GLKVertexAttribColor);
//    glDisable(GL_BLEND);
    glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
}

- (void)update {
    //    GLKMatrix4Translate(modelViewMatrix, _position->y, _position->x, _position->z);
    //    _rotation += 90 * self.timeSinceLastUpdate;
    //    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_rotation), 0, 0, 1);
    self.effect.transform.modelviewMatrix = [self currentModelViewTransform];
}

- (void)dealloc {
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
    
    
    self.effect = nil;
    
    delete (b2Vec2*)self.position;

}

+ (NSMutableArray*) Instances {
    static NSMutableArray* instancesList = nil;
    
    if (instancesList == nil) {
        instancesList = [[NSMutableArray alloc] init];
    }
    
    return instancesList;
}

/**
 *  Ensure that translation corresponding to this entity is performed before 
 *  drawing.
 **/
- (GLKMatrix4)currentModelViewTransform {
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, M_TO_PX(self.position->y), M_TO_PX(self.position->x), 0.0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, self.angle, 0.0, 0.0, 1.0);
    // add 10% to size since texture images are padded
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, M_TO_PX(self.height/2)*1.1, M_TO_PX(self.width/2)*1.1, 1.0f);
    
    return modelViewMatrix;
}

- (GLboolean) handlePan:(PanEntity *) pan {
    return false;
}

- (void) handlePanStarted {
    
}
- (void) handlePanEnded {
    
}
- (void) handlePanUpdate {
    
}

@end
