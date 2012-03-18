//
//  DragSelector.m
//  tulpasynth
//
//  Created by Colin Sullivan on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DragSelector.h"

@implementation DragSelector

@synthesize dragStart, dragEnd;

- (void) initialize {
    [super initialize];
    
    self.effect.texture2d0.enabled = GL_FALSE;
    self.effect.useConstantColor = YES;
    static float opacity = 0.25;
    self.effect.constantColor = GLKVector4Make(
                                               opacity,
                                               opacity,
                                               opacity,
                                               opacity
                                               );
    self.position->Set(20, 20);
    self.width = 30;
    self.height = 15;
}

- (void) update {
    [super update];
    
    // position is midpoint between drag start and drag end
    b2Vec2 midpoint;
    midpoint += dragStart;
    midpoint += dragEnd;
    midpoint *= 0.5;
    self.position->Set(midpoint.x, midpoint.y);
    
    // width is the width difference between drag start and end
    self.width = fabs(dragStart.x - dragEnd.x);
    self.height = fabs(dragStart.y - dragEnd.y);
    
}

/**
 *  Pan will always be handled as true by the drag selector.
 **/
- (GLboolean) handlePan:(PanEntity *) pan {
    if (pan->state == GestureEntityStateStart) {
        dragStart.Set(pan->touches[0]->position->x, pan->touches[0]->position->y);
        dragEnd.Set(pan->touches[0]->position->x, pan->touches[0]->position->y);
        // update here to draw 0-width highlight, clearing last one or else
        // single frame of old highlight will display
        [self update];
        self.active = true;
        self.panner = pan;
    }
    else if (pan->state == GestureEntityStateUpdate) {
        dragEnd.Set(pan->touches[0]->position->x, pan->touches[0]->position->y);
    }
    else if (pan->state == GestureEntityStateEnd) {
        dragEnd.Set(pan->touches[0]->position->x, pan->touches[0]->position->y);
        self.active = false;
        self.panner = nil;
    }
    
    return true;
}

@end
