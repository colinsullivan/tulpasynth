//
//  DragSelector.m
//  tulpasynth
//
//  Created by Colin Sullivan on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DragSelector.h"

#import "tulpaViewController.h"

@implementation DragSelector

@synthesize dragStart, dragEnd, shape;

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
    self.angle = 0.0;
}

- (void) update {
    [super update];
    
    if (!self.active) {
        return;
    }
    
    // position is midpoint between drag start and drag end
    b2Vec2 midpoint;
    midpoint += dragStart;
    midpoint += dragEnd;
    midpoint *= 0.5;
    self.position->Set(midpoint.x, midpoint.y);
    
    // width is the width difference between drag start and end
    self.width = fabs(dragStart.x - dragEnd.x);
    self.height = fabs(dragStart.y - dragEnd.y);
    
    // select obstacles within these bounds
    b2PolygonShape* oldShape = self.shape;

    self.shape = new b2PolygonShape();

    self.shape->SetAsBox(self.width/2.0, self.height/2.0, *(self.position), self.angle);

    delete (b2PolygonShape*)oldShape;
    
    [self.controller selectObstaclesWithinHighlight:self.shape];
}

/**
 *  Pan will always be handled as true by the drag selector.
 **/
- (GLboolean) handlePan:(PanEntity *) pan {
    if (pan->state == GestureEntityStateStart) {
        self.panner = pan;
        dragStart.Set(pan->touches[0]->position->x, pan->touches[0]->position->y);
        dragEnd.Set(pan->touches[0]->position->x, pan->touches[0]->position->y);
        self.active = true;
        // update here to draw 0-width highlight, clearing last one or else
        // single frame of old highlight will display
        [self update];
    }
    else if (pan->state == GestureEntityStateUpdate && self.panner == pan) {
        dragEnd.Set(pan->touches[0]->position->x, pan->touches[0]->position->y);
    }
    else if (pan->state == GestureEntityStateEnd && self.panner == pan) {
        self.panner = nil;
        dragEnd.Set(pan->touches[0]->position->x, pan->touches[0]->position->y);
        self.active = false;
    }
    
    return true;
}

@end
