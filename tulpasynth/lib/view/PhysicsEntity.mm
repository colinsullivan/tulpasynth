/**
 *  @file       PhysicsEntity.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "PhysicsEntity.h"

#import "tulpaViewController.h"

@implementation PhysicsEntity

@synthesize position, body, shape, shapeFixture;

@synthesize width, height, angle;

@synthesize pannable, panner, prePanningPosition;

@synthesize longPressable, longPresser;

@synthesize rotateable, rotator, preGestureAngle;

@synthesize pincheable, pincher, preScalingWidth, preScalingHeight;


- (b2Vec2*)position {
    b2Vec2 bodyPosition = self.body->GetPosition();
    
    position = new b2Vec2(bodyPosition.x, bodyPosition.y);
    return position;
}

- (void)setPosition:(b2Vec2*)aPosition {
    self.body->SetTransform(b2Vec2(aPosition->x, aPosition->y), -1*self.angle);
}

- (void)setAngle:(float32)anAngle {
    if (anAngle >= M_PI*2) {
        anAngle = anAngle - M_PI*2;
    }
    
    if (self.body) {
        self.body->SetTransform(self.body->GetPosition(), -1*anAngle);        
    }

    angle = anAngle;
}

- (void) initialize {
    
    [super initialize];
    
    self.prePanningPosition = new b2Vec2();
    self.pannable = true;
    
    self.longPressable = false;
    
    self.rotateable = true;
    
    self.pincheable = true;

    
    PhysicsEntityModel* model = ((PhysicsEntityModel*)self.model);

    // Create static body using initial position from model
    b2BodyDef bodyDef;
    bodyDef.position = b2Vec2([[model.initialPosition valueForKey:@"x"] floatValue], [[model.initialPosition valueForKey:@"y"] floatValue]);
    bodyDef.type = [self bodyType];
    b2Body* newBody = self.controller.world->CreateBody(&bodyDef);
    self.body = newBody;
    
    self.body->SetUserData(((__bridge void*)self));
    
    [[PhysicsEntity Instances] addObject:self];
        
}

- (void)dealloc {
    delete (b2Vec2*)self.prePanningPosition;
}

- (void) destroy {
    self.controller.world->DestroyBody(self.body);

    // destroy view by removing references
    try {
        [[PhysicsEntity Instances] removeObject:self];
    } catch (NSException * e) {
        if (e.name == NSRangeException) {
            NSLog(@"NSRangeException occurred PhysicsEntity Instances removeObject");
        }
        else {
            NSLog(@"other exception occurred PhysicsEntity Instances removeObject");
        }
    }
    
    try {
        [self.controller.wildBalls removeObject:self];
    } catch (NSException* e) {
        if (e.name == NSRangeException) {
            NSLog(@"NSRangeException occurred controller.wildBalls removeObject");
        }
        else {
            NSLog(@"other exception occurred wildBalls removeObject");
        }
    }
}


//- (void) update {
//    [super update];
//    
//}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];

//    NSLog(@"PhysicsEntity.observeValueForKeyPath\nkeyPath:\t%@\nchange:\t%@", keyPath, change);
    
    if ([keyPath isEqualToString:@"angle"]) {
        self.angle = [[change valueForKey:@"new"] floatValue];
    }
    else if ([keyPath isEqualToString:@"width"]) {
        self.width = [[change valueForKey:@"new"] floatValue];
    }
    else if ([keyPath isEqualToString:@"height"]) {
        self.height = [[change valueForKey:@"new"] floatValue];
    }
    else if ([keyPath isEqualToString:@"position"]) {
        self.position = new b2Vec2([[[change valueForKey:@"new"] valueForKey:@"x"] floatValue], [[[change valueForKey:@"new"] valueForKey:@"y"] floatValue]);
    }
}

+ (NSMutableArray*) Instances {
    static NSMutableArray* instancesList = nil;
    
    if (instancesList == nil) {
        instancesList = [[NSMutableArray alloc] init];
    }
    
    return instancesList;
}

- (b2BodyType) bodyType {
    return b2_staticBody;
}

- (GLKMatrix4)currentModelViewTransform {
    GLKMatrix4 modelViewMatrix = [super currentModelViewTransform];

    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, M_TO_PX(self.position->y), M_TO_PX(self.position->x), 0.0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, self.angle, 0.0, 0.0, 1.0);
    // add 10% to size since texture images are padded
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, M_TO_PX(self.height/2)*1.1, M_TO_PX(self.width/2)*1.1, 1.0f);
    
    return modelViewMatrix;
}

- (GLboolean) _touchIsInside:(TouchEntity *)touch withFudge:(float)fudgeFactor {
    b2Rot r(-1*self.angle);
    b2Transform obstaclePostion((*self.position), r);
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


- (GLboolean) handlePan:(PanEntity *) pan {
    if (self.pannable) {
        // if pan just started and we are allowing a pan
        if (pan->state == GestureEntityStateStart) {
            // if the touch is inside us
            if ([self _touchIsInside:pan->touches[0]]) {
                self.panner = pan;    
                
                [self handlePanStarted];
                
                
                
                return true;
            }
//            else if(self.panner) {
//                self.panner = nil;
//            }
        }
        else if (pan->state == GestureEntityStateUpdate && self.panner == pan) {
            [self handlePanUpdate];
            return true;
        }
        else if(pan->state == GestureEntityStateEnd && self.panner == pan) {
            [self handlePanEnded];
            self.panner = nil;
            return true;
        }
    }

    return false;
}

- (void) handlePanStarted {
    self.model.ignoreUpdates = true;
    self.prePanningPosition->Set(self.position->x, self.position->y);    
}

- (void) handlePanEnded {
    [self.model synchronize];
    self.model.ignoreUpdates = false;
}

- (void) handlePanUpdate {
    PhysicsEntityModel* model = (PhysicsEntityModel*)self.model;
    b2Vec2 newPos = (*self.prePanningPosition) + self.panner->translation;
    
    // save position to model
    model.position = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      [NSNumber numberWithFloat:newPos.x], @"x",
                      [NSNumber numberWithFloat:newPos.y], @"y",
                      nil];

}

- (GLboolean) handleTap:(TapEntity *) tap {
    if ([self _touchIsInside:tap->touches[0]]) {
        [self handleTapOccurred:tap];
        return true;
    }
    
    return false;
}

- (void) handleTapOccurred:(TapEntity*)tap {
    
}

- (GLboolean) handleLongPress:(LongPressEntity*)longPress {
    if (self.longPressable) {
        
        if (longPress->state == GestureEntityStateStart) {
            if ([self _touchIsInside:longPress->touches[0]]) {
                self.longPresser = longPress;
                [self handleLongPressStarted];
                return true;
            }
//            else if(self.longPresser) {
//                self.longPresser = nil;
//            }
        }
        else if (longPress->state == GestureEntityStateUpdate && self.longPresser == longPress) {
            [self handleLongPressUpdated];
            return true;
        }
        else if(longPress->state == GestureEntityStateEnd && self.longPresser == longPress) {
            [self handleLongPressEnded];
            self.longPresser = nil;
            return true;
        }
    }
    
    return false;
}

- (GLboolean) handleRotate:(RotateEntity *) rotate {
    if (self.rotateable) {
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
                
                [self handleRotateStarted];
                
                return true;
            }
            //        else if(self.rotator) {
            //            self.rotator = nil;
            //        }
        }
        else if(rotate->state == GestureEntityStateUpdate && self.rotator == rotate) {
            [self handleRotateUpdated];
            return true;
        }
        // if rotate gesture ended and we were just being rotated
        else if (rotate->state == GestureEntityStateEnd && self.rotator == rotate) {
            self.rotator = nil;
            
            [self.model synchronize];
            
            [self handleRotateEnded];
            
            return true;
            
        }

    }
    
    return false;
}

- (void) handleRotateStarted {
    self.model.ignoreUpdates = true;
}
- (void) handleRotateUpdated {
    PhysicsEntityModel* model = (PhysicsEntityModel*)self.model;
    model.angle = [NSNumber numberWithFloat:self.preGestureAngle + self.rotator->rotation];
}
- (void) handleRotateEnded {
    self.model.ignoreUpdates = false;
}

- (GLboolean) handlePinch:(PinchEntity *) pinch {
    if (self.pincheable) {
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
                
                [self handlePinchStarted];
                
                return true;
            }
            //        // incase we were watching an old pincher
            //        else if (self.pincher) {
            //            self.pincher = nil;
            //        }
        }
        else if(pinch->state == GestureEntityStateUpdate && self.pincher == pinch) {
            [self handlePinchUpdated];
            return true;
        }
        // if pinch has ended and we were following this pincher
        else if(pinch->state == GestureEntityStateEnd && self.pincher == pinch) {
            self.pincher = nil;
            
            [self.model synchronize];
            
            [self handlePinchEnded];
        }
    }    
    return false;
}

- (void) handlePinchStarted {
    PhysicsEntityModel* model = (PhysicsEntityModel*)self.model;
    model.ignoreUpdates = true;

}
- (void) handlePinchUpdated {
    PhysicsEntityModel* model = (PhysicsEntityModel*)self.model;
    model.width = [NSNumber numberWithFloat:self.preScalingWidth * self.pincher->scale];
    model.height = [NSNumber numberWithFloat:self.preScalingHeight * self.pincher->scale];
    
}
- (void) handlePinchEnded {
    PhysicsEntityModel* model = (PhysicsEntityModel*)self.model;
    model.ignoreUpdates = false;
}

- (void) handleCollision:(PhysicsEntity*)otherEntity withStrength:(float)collisionStrength {
    
}


@end
