//
//  Obstacle.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Obstacle.h"

@implementation Obstacle

@synthesize pincher;
@synthesize beforeScalingWidth;
@synthesize beforeScalingHeight;

@synthesize rotator;

@synthesize panner;
@synthesize prePanningPosition;

- (id)initWithController:(tulpaViewController *)theController withPosition:(b2Vec2)aPosition {
    if (self = [super initWithController:theController withPosition:aPosition]) {
        self.prePanningPosition = new b2Vec2();
    }
    
    return self;
}

- (void)dealloc {
    delete self.prePanningPosition;
}

- (void)update {
    [super update];
    
    if (self.panner) {
        self.position = (*self.prePanningPosition) + self.panner->translation;
    }
//    
//    if (self.pincher) {
//        self.width = self.beforeScalingWidth * self.pincher->scale;
//        self.height = self.beforeScalingHeight * self.pincher->scale;
//    }
//    
//    if (self.rotator) {
//        self.rotation = self.preGestureRotation + self.rotator->rotation;
//        
//        if (self.rotation > 2 * M_PI) {
//            self.rotation -= 2*M_PI;
//        }
//    }
}

- (GLboolean) _touchIsInside:(TouchEntity *)touch withFudge:(float)fudgeFactor {
    b2Rot r(0);
    b2Transform t(self.position, r);
    b2Vec2 p = (*touch->position);
    
    if (self.shape->TestPoint(t, p)) {
        return true;
    }
    
    return false;
}

- (GLboolean) _touchIsInside:(TouchEntity *)touch {
    return [self _touchIsInside:touch withFudge:0];
}

- (GLboolean) handlePinch:(PinchEntity *) pinch {
//    // If pinch just started
//    if (pinch->state == GestureEntityStateStart) {
//        // If both touches are in us
//        if (
//            [self _touchIsInside:pinch->touches[0] withFudge:25]
//            &&
//            [self _touchIsInside:pinch->touches[1] withFudge:25]
//            ) {
//            self.pincher = pinch;
//            self.beforeScalingWidth = self.width;
//            self.beforeScalingHeight = self.height;
//            
//            return true;
//        }
//        // incase we were watching an old pincher
//        else if (self.pincher) {
//            self.pincher = nil;
//        }
//    }
//    // if pinch has ended and we were following this pincher
//    else if(pinch->state == GestureEntityStateEnd && self.pincher) {
//        self.pincher = nil;
//    }
    
    return false;
}

- (GLboolean) handleRotate:(RotateEntity *) rotate {
//    // if rotate just started
//    if (rotate->state == GestureEntityStateStart) {
//        // if both touches are in us
//        if (
//            [self _touchIsInside:rotate->touches[0] withFudge:20]
//            &&
//            [self _touchIsInside:rotate->touches[0] withFudge:20]
//            ) {
//            self.rotator = rotate;
//            self.preGestureRotation = self.rotation;
//            
//            return true;
//        }
//        else if(self.rotator) {
//            self.rotator = nil;
//        }
//    }
//    // if rotate gesture ended and we were just being rotated
//    else if (rotate->state == GestureEntityStateEnd && self.rotator) {
//        self.rotator = nil;
//    }
//    
    return false;
}

- (GLboolean) handlePan:(PanEntity *) pan {
    // if pan just started
    if (pan->state == GestureEntityStateStart) {
        // if the touch is inside us
        if ([self _touchIsInside:pan->touches[0]]) {
            self.panner = pan;
            
            NSLog(@"self.position.x: %f, self.position.y: %f", self.position.x, self.position.y);
            
            self.prePanningPosition->Set(self.position.x, self.position.y);
            
            NSLog(@"self.prePanningPosition.x: %f, self.prePanningPosition.y: %f", self.prePanningPosition->x, self.prePanningPosition->y);
            return true;
        }
        else if(self.panner) {
            self.panner = nil;
        }
    }
    else if(pan->state == GestureEntityStateEnd && self.panner) {
        self.panner = nil;
    }
    
    return false;
}

- (GLboolean) handleTap:(TapEntity *) tap {
//    if ([self _touchIsInside:tap->touches[0]]) {
//        return true;
//    }
    
    return false;
}

@end
