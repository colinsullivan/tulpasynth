//
//  GfxEntity.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GfxEntity.h"


@implementation GfxEntity

@synthesize effect;
@synthesize position;
@synthesize width;
@synthesize height;

@synthesize rotation;
@synthesize preGestureRotation;


- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, 320, 480, 0, -1, 1);
    
    self.position = new Vector3D();
    self.rotation = 0;
    
    glGenBuffers(1, &_vertexBuffer);
    
    glGenBuffers(1, &_indexBuffer);
    
    return self;
}

- (void)dealloc {
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
    
    self.effect = nil;
    delete self.position;
}

- (void)draw {
    
    [self.effect prepareToDraw];
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Color));
    
}

- (void)update {
    // Width and height are switched here because this app only works when rotated
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(self.position->y, self.position->x, self.position->z);
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, self.width/2, self.height/2, 1.0f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, self.rotation, 0.0, 0.0, 1.0);
    //    GLKMatrix4Translate(modelViewMatrix, _position->y, _position->x, _position->z);
    //    _rotation += 90 * self.timeSinceLastUpdate;
    //    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_rotation), 0, 0, 1);
    self.effect.transform.modelviewMatrix = modelViewMatrix;
}

@end
