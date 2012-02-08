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
@synthesize draggingOffset;

@synthesize pincher;
@synthesize beforeScalingWidth;
@synthesize beforeScalingHeight;

@synthesize rotator;


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
            (*self.position) = (*self.dragger->position) + self.draggingOffset;
        }
        else {
            self.dragger = nil;
        }
    }
    
    if (self.pincher) {
        self.width = self.beforeScalingWidth * self.pincher->scale;
        self.height = self.beforeScalingHeight * self.pincher->scale;
    }
    
    if (self.rotator) {
        self.rotation = self.preGestureRotation + self.rotator->rotation;
        
        if (self.rotation > 2 * M_PI) {
            self.rotation -= 2*M_PI;
        }
    }
}

- (GLboolean) _touchIsInside:(TouchEntity *)touch withFudge:(float)fudgeFactor {
    if (
        touch->position->x <= self.position->x + self.width/2 + fudgeFactor
        &&
        touch->position->x >= self.position->x - self.width/2 - fudgeFactor
        &&
        touch->position->y <= self.position->y + self.width/2 + fudgeFactor
        &&
        touch->position->y >= self.position->y - self.width/2 - fudgeFactor
    ) {

        return true;
    }
    
    return false;
}

- (GLboolean) _touchIsInside:(TouchEntity *)touch {
    return [self _touchIsInside:touch withFudge:0];
}

- (GLboolean) handleTouch:(TouchEntity *) touch {
    
    if (
        [self _touchIsInside:touch]
        &&
        self.dragger != touch
    ) {
        self.draggingOffset = (*self.position) - (*touch->position);
        self.dragger = touch;
        
        return true;
    }
    
    return false;
}

- (GLboolean) handlePinch:(PinchEntity *) pinch {
    // If pinch just started
    if (pinch->state == GestureEntityStateStart) {
        // If both touches are in us
        if (
            [self _touchIsInside:pinch->touches[0] withFudge:20]
            &&
            [self _touchIsInside:pinch->touches[1] withFudge:20]
        ) {
            self.pincher = pinch;
            self.beforeScalingWidth = self.width;
            self.beforeScalingHeight = self.height;
            
            return true;
        }
        // incase we were watching an old pincher
        else if (self.pincher) {
            self.pincher = nil;
        }
    }
    // if pinch has ended and we were following this pincher
    else if(pinch->state == GestureEntityStateEnd && self.pincher) {
        self.pincher = nil;
    }
    
    return false;
}

- (GLboolean) handleRotate:(RotateEntity *) rotate {
    // if rotate just started
    if (rotate->state == GestureEntityStateStart) {
        // if both touches are in us
        if (
            [self _touchIsInside:rotate->touches[0] withFudge:20]
            &&
            [self _touchIsInside:rotate->touches[0] withFudge:20]
        ) {
            self.rotator = rotate;
            self.preGestureRotation = self.rotation;
            
            return true;
        }
        else if(self.rotator) {
            self.rotator = nil;
        }
    }
    // if rotate gesture ended and we were just being rotated
    else if (rotate->state == GestureEntityStateEnd && self.rotator) {
        self.rotator = nil;
    }
    
    return false;
}

@end
