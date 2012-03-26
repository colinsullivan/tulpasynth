/**
 *  @file       GLView.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

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

@synthesize effect, effect1, scalingMultiplier;

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
    
    self.effect1 = [[GLKBaseEffect alloc] init];
    self.effect1.transform.projectionMatrix = GLKMatrix4MakeOrtho(
                                                                  0,
                                                                  self.controller.view.frame.size.width,
                                                                  self.controller.view.frame.size.height,
                                                                  0,
                                                                  -1,
                                                                  1);

    self.effect.texture2d0.enabled = GL_TRUE;
    self.effect.texture2d0.envMode = GLKTextureEnvModeModulate;
    self.effect.texture2d0.target = GLKTextureTarget2D;
    
    self.effect1.texture2d0.enabled = GL_FALSE;
    self.effect1.texture2d0.envMode = GLKTextureEnvModeModulate;
    self.effect1.texture2d0.target = GLKTextureTarget2D;

    
    // by default, scale by 110% because most texture images have about 10% padding.
    self.scalingMultiplier = 1.1;
    
    self.panner = nil;

    [[GLView Instances] addObject:self];
}

- (Vertex*)vertices {
    return NULL;
}
- (GLubyte*)indices {
    return NULL;
}
- (void)_bindAndEnable {

}

- (void)prepareToDraw {
    [self.effect prepareToDraw];
    [self _bindAndEnable];
}

- (void)prepareToDraw1 {
    [self.effect1 prepareToDraw];
    [self _bindAndEnable];
}

- (void)draw {
    
    if (self.active) {

        //    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Color));    
        
        
        
        //    glDrawElements(GL_TRIANGLES, sizeof([self indices])/sizeof([self indices][0]), GL_UNSIGNED_BYTE, 0);
        glDrawElements(GL_TRIANGLES, sizeof(SquareIndices)/sizeof(SquareIndices[0]), GL_UNSIGNED_BYTE, 0);
    }
}

- (void)_disable {
//    glDisableVertexAttribArray(GLKVertexAttribPosition);
    //    glDisableVertexAttribArray(GLKVertexAttribColor);
    //    glDisable(GL_BLEND);
//    glDisableVertexAttribArray(GLKVertexAttribTexCoord0);    
}

- (void)postDraw {
    
    [self _disable];
    
    // if effect1 is enabled
    if (self.effect1.texture2d0.enabled == GL_TRUE) {
        [self prepareToDraw1];
        [self draw];
        [self postDraw1];
    }
}

- (void)postDraw1 {
    [self _disable];
}

- (void)update {
    //    GLKMatrix4Translate(modelViewMatrix, _position->y, _position->x, _position->z);
    //    _rotation += 90 * self.timeSinceLastUpdate;
    //    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_rotation), 0, 0, 1);
    self.effect.transform.modelviewMatrix = [self currentModelViewTransform];
    self.effect1.transform.modelviewMatrix = [self currentModelViewTransform];
}

- (void)dealloc {
//    glDeleteBuffers(1, &_vertexBuffer);
//    glDeleteBuffers(1, &_indexBuffer);
    
    
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
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, M_TO_PX(self.height/2)*self.scalingMultiplier, M_TO_PX(self.width/2)*self.scalingMultiplier, 1.0f);
    
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

+ (GLuint)vertexBuffer {
    static GLuint _vertexBuffer;
    
    if (!_vertexBuffer) {
        glGenBuffers(1, &_vertexBuffer);        
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(SquareVertices), SquareVertices, GL_STATIC_DRAW);        
    }
    
    return _vertexBuffer;
}
+ (GLuint)indexBuffer {
    static GLuint _indexBuffer;
    
    if (!_indexBuffer) {
        glGenBuffers(1, &_indexBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(SquareIndices), SquareIndices, GL_STATIC_DRAW);
    }
    
    return _indexBuffer;
}

+ (void) initializeBuffers {
    
    glBindBuffer(GL_ARRAY_BUFFER, [[GLView class] vertexBuffer]);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, TexCoord));
    
    //    glEnableVertexAttribArray(GLKVertexAttribColor);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, [[GLView class] indexBuffer]);

}

@end
