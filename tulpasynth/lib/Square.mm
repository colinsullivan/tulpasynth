//
//  Square.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Square.h"

#include "mo_gfx.h"
#include "Globals.h"


static Vertex SquareVertices[] = {
    {{1, -1, 0}, {0, 0, 0}},
    {{1, 1, 0}, {0, 0, 0}},
    {{-1, 1, 0}, {0, 0, 0}},
    {{-1, -1, 0}, {0, 0, 0}}
};



const GLubyte SquareIndices[] = {
    0, 1, 2,
    2, 3, 0
};

@interface Square() {

@private
    Vector3D pos;
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
}
@end

@implementation Square

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(SquareVertices), SquareVertices, GL_STATIC_DRAW);

    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(SquareIndices), SquareIndices, GL_STATIC_DRAW);
    
    return self;
}

- (void)dealloc {
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);    
}

- (void)draw {
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);

    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Color));
    glDrawElements(GL_TRIANGLES, sizeof(SquareIndices)/sizeof(SquareIndices[0]), GL_UNSIGNED_BYTE, 0);

}

@end
