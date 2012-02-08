//
//  FallingBall.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FallingBall.h"

static Vertex BallVertices[] = {
    {{1, -1, 0}, {0, 0.5, 0.5}},
    {{1, 1, 0}, {0, 0.5, 0.5}},
    {{-1, 1, 0}, {0, 0.5, 0.5}},
    {{-1, -1, 0}, {0, 0.5, 0.5}}
};


const GLubyte BallIndices[] = {
    0, 1, 2,
    2, 3, 0
};


@implementation FallingBall

@synthesize velocity;

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.width = 25;
    self.height = 25;
    
    self.velocity = new Vector3D(0, -100, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(BallVertices), BallVertices, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(BallIndices), BallIndices, GL_STATIC_DRAW);
    
    return self;
}

- (void)dealloc {
    delete self.velocity;
}

- (void)update {
    [super update];
    
    // Calculate new instantaneous position based on current velocity
//    self.position->x *= self.velocity->x;
    self.position->y += self.velocity->y * self.controller.timeSinceLastUpdate;
    
    // Accelerate
    self.velocity->y -= 100 * self.controller.timeSinceLastUpdate;
}

- (void)draw {
    [super draw];
    
    glDrawElements(GL_TRIANGLES, sizeof(BallIndices)/sizeof(BallIndices[0]), GL_UNSIGNED_BYTE, 0);
}


@end
