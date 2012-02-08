//
//  GfxEntity.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GfxEntity.h"


@implementation GfxEntity

@synthesize effect = _effect;
@synthesize position = _position;
@synthesize width = _width;
@synthesize height = _height;

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _effect = [[GLKBaseEffect alloc] init];
    _effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, 320, 480, 0, -1, 1);
    
    _position = new Vector3D(0, 0, 0);
    
    glGenBuffers(1, &_vertexBuffer);
    
    glGenBuffers(1, &_indexBuffer);
    
    return self;
}

- (void)dealloc {
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
    
    _effect = nil;
}

- (void)draw {
    
    [_effect prepareToDraw];
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Color));
    
}

- (void)update {
    // Width and height are switched here because this app only works when rotated
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(_position->y, _position->x, _position->z);
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, _width/2, _height/2, 1.0f);
    //    GLKMatrix4Translate(modelViewMatrix, _position->y, _position->x, _position->z);
    //    _rotation += 90 * self.timeSinceLastUpdate;
    //    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_rotation), 0, 0, 1);
    self.effect.transform.modelviewMatrix = modelViewMatrix;
}

@end
