//
//  GLView.mm
//  tulpasynth
//
//  Created by Colin Sullivan on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GLView.h"
#import "tulpaViewController.h"

// Texture coordinates are rotated 90 degrees because this app only works in
// landscape.  I know, how budget.
static Vertex SquareVertices[] = {
    {{1, -1, 0}, {0.0, 0.0, 0.0, 1.0}, {1, 1}},
    {{1, 1, 0}, {0.0, 0.0, 0.0, 1.0}, {0, 1}},
    {{-1, 1, 0}, {0.0, 0.0, 0.0, 1.0}, {0, 0}},
    {{-1, -1, 0}, {0.0, 0.0, 0.0, 1.0}, {1, 0}}
};


static GLubyte SquareIndices[] = {
    0, 1, 2,
    2, 3, 0
};

@implementation GLView

@synthesize effect;

- (void) initialize {
    
    [super initialize];
    
    // Shader for this object
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, self.controller.view.frame.size.width, self.controller.view.frame.size.height, 0, -1, 1);

    // Vertex buffers
    glGenBuffers(1, &_vertexBuffer);        
    glGenBuffers(1, &_indexBuffer);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
//    glBufferData(GL_ARRAY_BUFFER, sizeof(_vertices), _vertices, GL_DYNAMIC_DRAW);
    glBufferData(GL_ARRAY_BUFFER, sizeof(SquareVertices), SquareVertices, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
//    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof([self indices]), [self indices], GL_STATIC_DRAW);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(SquareIndices), SquareIndices, GL_DYNAMIC_DRAW);

    [[GLView Instances] addObject:self];
}

- (Vertex*)vertices {
    return NULL;
}
- (GLubyte*)indices {
    return NULL;
}

- (void)prepareToDraw {
    self.effect.texture2d0.enabled = GL_TRUE;
    self.effect.texture2d0.envMode = GLKTextureEnvModeModulate;
    self.effect.texture2d0.target = GLKTextureTarget2D;
    
    [self.effect prepareToDraw];
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
//    glEnableVertexAttribArray(GLKVertexAttribColor);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);

    glEnable(GL_BLEND);
    glBlendFunc( GL_ONE, GL_ONE_MINUS_SRC_ALPHA );
}

- (void)draw {
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));
//    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Color));    
    
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, TexCoord));
    
//    glDrawElements(GL_TRIANGLES, sizeof([self indices])/sizeof([self indices][0]), GL_UNSIGNED_BYTE, 0);
    glDrawElements(GL_TRIANGLES, sizeof(SquareIndices)/sizeof(SquareIndices[0]), GL_UNSIGNED_BYTE, 0);

}

- (void)postDraw {
    glDisableVertexAttribArray(GLKVertexAttribPosition);
//    glDisableVertexAttribArray(GLKVertexAttribColor);
    glDisable(GL_BLEND);
    glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
}

- (void)update {
    //    GLKMatrix4Translate(modelViewMatrix, _position->y, _position->x, _position->z);
    //    _rotation += 90 * self.timeSinceLastUpdate;
    //    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_rotation), 0, 0, 1);
    self.effect.transform.modelviewMatrix = [self currentModelViewTransform];
}

- (GLKMatrix4)currentModelViewTransform {
    return GLKMatrix4Identity;
}

- (void)dealloc {
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
    
    self.effect = nil;
}

+ (NSMutableArray*) Instances {
    static NSMutableArray* instancesList = nil;
    
    if (instancesList == nil) {
        instancesList = [[NSMutableArray alloc] init];
    }
    
    return instancesList;
}


@end
