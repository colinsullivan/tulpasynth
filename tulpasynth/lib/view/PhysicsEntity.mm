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
    self.pannable = false;
    
    self.longPressable = false;

    
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
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, M_TO_PX(self.height/2), M_TO_PX(self.width/2), 1.0f);
    
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
    self.prePanningPosition->Set(self.position->x, self.position->y);    
}

- (void) handlePanEnded {
    [self.model synchronize];
}

- (void) handlePanUpdate {
    
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

@end
