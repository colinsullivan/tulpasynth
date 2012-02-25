/**
 *  @file       Obstacle.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "Obstacle.h"

#import "tulpaViewController.h"

@implementation Obstacle

@synthesize pincher, preScalingWidth, preScalingHeight;

@synthesize rotator, preGestureAngle;

@synthesize panner;
@synthesize prePanningPosition;

- (id)initWithController:(tulpaViewController *)theController withModel:(ObstacleModel*)aModel {
    if (self = [super initWithController:theController withModel:aModel]) {
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
    
    if (self.pincher) {
        [self setWidth:self.preScalingWidth * self.pincher->scale withHeight:self.preScalingHeight*self.pincher->scale];
        
    }
    
    if (self.rotator) {
        self.angle = self.preGestureAngle + self.rotator->rotation;        
    }
}

- (GLboolean) _touchIsInside:(TouchEntity *)touch withFudge:(float)fudgeFactor {
    b2Rot r(0);
    b2Transform obstaclePostion(self.position, r);
    b2Vec2 touchPosition(touch->position->x, touch->position->y);
    
    b2Vec2 touchPositionFudged[5];
    touchPositionFudged[0] = touchPosition;
    touchPositionFudged[1].Set(touch->position->x - fudgeFactor, touch->position->y);
    touchPositionFudged[2].Set(touch->position->x, touch->position->y - fudgeFactor);
    touchPositionFudged[3].Set(touch->position->x + fudgeFactor, touch->position->y);
    touchPositionFudged[4].Set(touch->position->x, touch->position->y + fudgeFactor);
    
    for (int i = 0; i < 5; i++) {
        if (self.shape->TestPoint(obstaclePostion, touchPositionFudged[i])) {
            return true;
        }
    }
    
    return false;
}

- (GLboolean) _touchIsInside:(TouchEntity *)touch {
    return [self _touchIsInside:touch withFudge:0];
}

- (GLboolean) handlePinch:(PinchEntity *) pinch {
    // If pinch just started
    if (pinch->state == GestureEntityStateStart) {
        // If both touches are in us
        if (
            [self _touchIsInside:pinch->touches[0] withFudge:15]
            &&
            [self _touchIsInside:pinch->touches[1] withFudge:15]
            ) {
            self.pincher = pinch;
            self.preScalingWidth = self.width;
            self.preScalingHeight = self.height;
            
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
            [self _touchIsInside:rotate->touches[1] withFudge:20]
            ) {
            self.rotator = rotate;
            self.preGestureAngle = self.angle;
            
            return true;
        }
        else if(self.rotator) {
            self.rotator = nil;
        }
    }
    // if rotate gesture ended and we were just being rotated
    else if (rotate->state == GestureEntityStateEnd && self.rotator) {
        self.rotator = nil;
        
        // save angle to model
        ObstacleModel* model = ((ObstacleModel*)(self.model));
        model.angle = [NSNumber numberWithFloat:self.angle];
    }
    
    return false;
}

- (GLboolean) handlePan:(PanEntity *) pan {
    // if pan just started
    if (pan->state == GestureEntityStateStart) {
        // if the touch is inside us
        if ([self _touchIsInside:pan->touches[0] withFudge:20]) {
            self.panner = pan;            
            self.prePanningPosition->Set(self.position.x, self.position.y);
    
            return true;
        }
        else if(self.panner) {
            self.panner = nil;
        }
    }
    else if(pan->state == GestureEntityStateEnd && self.panner) {
        self.panner = nil;
        
        // save position to model
        ObstacleModel* model = ((ObstacleModel*)(self.model));
        model.position = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithFloat:self.position.x], @"x",
                          [NSNumber numberWithFloat:self.position.y], @"y",
                          nil];
    }
    
    return false;
}

- (GLboolean) handleTap:(TapEntity *) tap {
    if ([self _touchIsInside:tap->touches[0]]) {
        return true;
    }
    
    return false;
}

@end
