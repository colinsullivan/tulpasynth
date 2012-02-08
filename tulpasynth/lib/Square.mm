//
//  Square.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Square.h"

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

@implementation Square

@synthesize dragger;

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.width = 50;
    self.height = 50;

    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(SquareVertices), SquareVertices, GL_STATIC_DRAW);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(SquareIndices), SquareIndices, GL_STATIC_DRAW);

    return self;
}

- (void)draw {
    [super draw];

    glDrawElements(GL_TRIANGLES, sizeof(SquareIndices)/sizeof(SquareIndices[0]), GL_UNSIGNED_BYTE, 0);
}

- (void)update {
    [super update];
    
    if (self.dragger) {
        if (self.dragger->active) {
            (*self.position) = (*self.dragger->position);
        }
        else {
            self.dragger = nil;
        }
    }
}

- (GLboolean) handleTouch:(TouchEntity *) touch {
    
    if (
        touch->position->x <= self.position->x + self.width/2
        &&
        touch->position->x >= self.position->x - self.width/2
        &&
        touch->position->y <= self.position->y + self.width/2
        &&
        touch->position->y >= self.position->y - self.width/2
        &&
        self.dragger != touch
    ) {
        self.dragger = touch;
        
        return true;
    }
    
    return false;
    
}

@end
