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


- (void) initialize {
    [super initialize];
    
    self.pannable = true;
}

- (void)update {
    [super update];

    ObstacleModel* model = ((ObstacleModel*)(self.model));

    if (self.pincher) {
        model.width = [NSNumber numberWithFloat:self.preScalingWidth * self.pincher->scale];
        model.height = [NSNumber numberWithFloat:self.preScalingHeight * self.pincher->scale];
    }
    
    if (self.rotator) {
        model.angle = [NSNumber numberWithFloat:self.preGestureAngle + self.rotator->rotation];
    }
}

- (void) handlePanUpdate {
    
    [super handlePanUpdate];
    
    ObstacleModel* model = ((ObstacleModel*)(self.model));

    b2Vec2 newPos = (*self.prePanningPosition) + self.panner->translation;
    
    // save position to model
    model.position = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      [NSNumber numberWithFloat:newPos.x], @"x",
                      [NSNumber numberWithFloat:newPos.y], @"y",
                      nil];
}


- (GLboolean) handlePinch:(PinchEntity *) pinch {
    // If pinch just started
    if (pinch->state == GestureEntityStateStart) {
        // If both touches are in us
        if (
            [self _touchIsInside:pinch->touches[0] withFudge:2.0]
            &&
            [self _touchIsInside:pinch->touches[1] withFudge:2.0]
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
        
        [self.model synchronize];
    }
    
    return false;
}

- (GLboolean) handleRotate:(RotateEntity *) rotate {
    // if rotate just started
    if (rotate->state == GestureEntityStateStart) {
        // if both touches are in us
        if (
            [self _touchIsInside:rotate->touches[0] withFudge:2.0]
            &&
            [self _touchIsInside:rotate->touches[1] withFudge:2.0]
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
        
        [self.model synchronize];
    }
    
    return false;
}

@end
