/**
 *  @file       Toolbar.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "Toolbar.h"

#import "tulpaViewController.h"

@implementation Toolbar

@synthesize closed, open, prototypes;

@synthesize squarePrototype, shooterPrototype, triPrototype, blackholePrototype;
@synthesize addingRing;


//- (const b2Vec2&)position {
//    offsetPosition.Set([super position].x, [super position].y);
//    
//    b2PolygonShape* shape = ((b2PolygonShape*)self.shape);
//    
//    if (shape) {
//        offsetPosition.x += shape->m_centroid.x;
//        offsetPosition.y += shape->m_centroid.y;
//    }
//    
//    
//    return offsetPosition;
//}

- (void) setPosition:(b2Vec2*)aPosition {
    
    // closed position
    b2Vec2 closedPosition;
    closedPosition.Set(-self.width/2.0, self.height/2.0);
    
    b2Vec2 openPosition;
    openPosition.Set(-self.width/2.0 + 12.0, self.height/2.0);
    
    // left bounds
    if (aPosition->x <= closedPosition.x) {
        aPosition->x = closedPosition.x;
        self.closed = true;
        self.open = false;
        self.body->SetLinearVelocity(b2Vec2(0.0, 0.0));
    }
    else {
        self.closed = false;
    }
    
    // right bounds
    if (aPosition->x >= openPosition.x) {
        aPosition->x = openPosition.x;
        self.closed = false;
        self.open = true;
        self.body->SetLinearVelocity(b2Vec2(0.0, 0.0));
    }
    else {
        self.open = false;
    }
    
    float prototypeX = aPosition->x + self.width/2.0 - 6.5;
    float prototypeY = 4;
    
    self.squarePrototype.position = new b2Vec2(
                                               prototypeX,
                                               prototypeY
                                               );
    self.shooterPrototype.position = new b2Vec2(
                                                prototypeX,
                                                prototypeY + 10
                                                );
    
    self.triPrototype.position = new b2Vec2(
                                            prototypeX,
                                            prototypeY + 20
                                            );
    
    self.blackholePrototype.position = new b2Vec2(
                                                  prototypeX,
                                                  prototypeY + 30
                                                  );

    
    [super setPosition:aPosition];
}

- (void) initialize {
    [super initialize];
    
    self.pannable = true;
    
    self.prototypes = [[NSMutableArray alloc] init];

    
    self.width = PX_TO_M(768);
    self.height = PX_TO_M(768);
    
    self.angle = 0.0;

    self.position = new b2Vec2(-self.width/2.0, self.height/2.0);
    
    self.shape = new b2PolygonShape();
    self.shape->m_radius = 1.0f;
    ((b2PolygonShape*)self.shape)->SetAsBox(self.width/2.0, self.height/2.0);
    
    b2FixtureDef mySquareFixture;
    mySquareFixture.shape = self.shape;    
    self.shapeFixture = self.body->CreateFixture(&mySquareFixture);
    
    b2Filter filterData;
    filterData.groupIndex = 2;
    self.shapeFixture->SetFilterData(filterData);
    
    filterData.groupIndex = 1;
    // Create object prototypes
    self.squarePrototype = [[BlockObstacle alloc] initWithController:self.controller withModel:NULL];
    self.squarePrototype.width = [[[BlockModel defaultAttributes] valueForKey:@"width"] floatValue];
    self.squarePrototype.height = [[[BlockModel defaultAttributes] valueForKey:@"height"] floatValue];
    self.squarePrototype.shapeFixture->SetFilterData(filterData);
    [self.prototypes addObject:self.squarePrototype];
    
    self.shooterPrototype = [[Shooter alloc] initWithController:self.controller withModel:NULL];
    self.shooterPrototype.width = [[[ShooterModel defaultAttributes] valueForKey:@"width"] floatValue];
    self.shooterPrototype.height = [[[ShooterModel defaultAttributes] valueForKey:@"height"] floatValue];
    self.shooterPrototype.angle = [[[ShooterModel defaultAttributes] valueForKey:@"angle"] floatValue];
    self.shooterPrototype.shapeFixture->SetFilterData(filterData);
    [self.prototypes addObject:self.shooterPrototype];
    
    self.triPrototype = [[TriObstacle alloc] initWithController:self.controller withModel:NULL];
    [self.triPrototype setWidth:[[[TriObstacleModel defaultAttributes] valueForKey:@"width"] floatValue] withHeight:[[[TriObstacleModel defaultAttributes] valueForKey:@"height"] floatValue]];
    self.triPrototype.angle = [[[TriObstacleModel defaultAttributes] valueForKey:@"angle"] floatValue];
    self.triPrototype.shapeFixture->SetFilterData(filterData);
    [self.prototypes addObject:self.triPrototype];
    
    self.blackholePrototype = [[Blackhole alloc] initWithController:self.controller withModel:NULL];
    self.blackholePrototype.width = [[[BlackholeModel defaultAttributes] valueForKey:@"width"] floatValue];
    self.blackholePrototype.height = [[[BlackholeModel defaultAttributes] valueForKey:@"height"] floatValue];
    self.blackholePrototype.shapeFixture->SetFilterData(filterData);
    [self.prototypes addObject:self.blackholePrototype];

//    b2MassData myBodyMass;
//    myBodyMass.mass = 1.0f;
//    self.body->SetMassData(&myBodyMass);

    
    self.body->SetGravityScale(0.0);
    
    self.scalingMultiplier = 1.0;
    
    // joint between right wall and toolbar
//    b2MouseJointDef jointDef;
//    jointDef.target = b2Vec2(
//                             -10.0 + self.width*2.0, 
//                             self.height/2.0
//                             );
//    jointDef.bodyB = self.body;
//    jointDef.bodyA = self.controller.walls;
//    jointDef.frequencyHz = 20.0f;
//    jointDef.dampingRatio = 0.1f;
//    jointDef.maxForce = 4000.0f * self.body->GetMass();
//    self.mouseJoint = (b2MouseJoint*)self.controller.world->CreateJoint(&jointDef);
    self.effect.texture2d0.name = self.controller.toolbarTexture.name;
    
    // toolbox is initially closed
    self.closed = true;
    self.open = false;
    
    self.addingRing = [[AddingRing alloc] initWithController:self.controller withModel:NULL];

}

- (b2BodyType) bodyType {
    return b2_dynamicBody;
}

- (GLboolean) handlePan:(PanEntity *)pan {
    // if toolbox is closed
    if (self.closed) {
//        // catch pan gestures that start towards the left side of screen
//        if (pan->state == GestureEntityStateStart) {
////            NSLog(@"pan->touches[0]->position->x: %f", pan->touches[0]->position->x);
//            if (pan->touches[0]->position->x < 10.0) {
//                self.panner = pan;
//                [self handlePanStarted];
//                return true;
//            }
//        }
//        // continue pan gestures
//        else if (pan->state == GestureEntityStateUpdate && self.panner == pan) {
//            return [super handlePan:pan];
//        }
//        else if (pan->state == GestureEntityStateEnd && self.panner == pan) {
//            return [super handlePan:pan];
//        }
    }
    else {
//        // toolbox is open, see if pan was on an object prototype
//        
//        for (PhysicsEntity* proto in self.prototypes) {
//            if ([proto handlePan:pan]) {
//                NSLog(@"prototype handled the pan");
//                
//                if (pan->state == GestureEntityStateUpdate) {
//                    // move prototype with pan
//                    b2Vec2 newPos = (*proto.prePanningPosition) + pan->translation;
////                    proto.position = new b2Vec2(newPos.x, newPos.y);
//                    proto.position = &newPos;
//                }
//                
//                return true;
//            }
//        }
        
//        NSLog(@"super handlePan");
        return [super handlePan:pan];
    }
    
    return false;
}

- (void) update {
    [super update];
    
    // Keep position up to date
    b2Transform currentTransform = self.body->GetTransform();
    self.position = &currentTransform.p;
    
    for (PhysicsEntity* e in self.prototypes) {
        [e update];
    }
    
    [self.addingRing update];
}


- (void) handlePanStarted {
    [super handlePanStarted];
//    NSLog(@"handlePanStarted");
    self.body->SetLinearVelocity(b2Vec2(0.0, 0.0));
    self.closed = false;
    
    [self handlePanUpdate];
}

- (void) handlePanEnded {
//    NSLog(@"self.panner->velocity.x: %f", self.panner->velocity.x);
//    self.body->SetLinearVelocity(b2Vec2(self.panner->velocity.x, 0));
//    self.body->ApplyForceToCenter(b2Vec2(self.panner->velocity.x, 0.0));
    self.body->ApplyLinearImpulse(
                                  b2Vec2(self.panner->velocity.x*0.25, 0.0),
                                  (*self.position)
                                  );
}

- (void) handlePanUpdate {
    b2Vec2* newPos = self.prePanningPosition;
    newPos->x += self.panner->translation.x*0.25;
    self.position = newPos;   
}

- (void) animateOpen:(b2Vec2*)ringLocation {
    self.position = new b2Vec2(self.position->x+1.0, self.position->y);
    self.body->ApplyLinearImpulse(
                                  b2Vec2(50.0, 0.0), (*self.position)
                                  );
    
    // place ring
    self.addingRing.position = new b2Vec2(ringLocation->x, ringLocation->y);
    self.addingRing.active = true;
}

- (void)setClosed:(BOOL)isClosed {
    if (isClosed) {
        self.addingRing.active = false;
    }
    
    closed = isClosed;
}

- (void) animateClosed {
    self.position = new b2Vec2(self.position->x-1.0, self.position->y);
    self.body->ApplyLinearImpulse(
                                  b2Vec2(-50.0, 0.0), (*self.position)
                                  );
}

- (void) postDraw {
    [super postDraw];
    if (self.active) {
        
        for (PhysicsEntity* e in self.prototypes) {
            [e prepareToDraw];
            [e draw];
            [e postDraw];
        }
        
        [self.addingRing prepareToDraw];
        [self.addingRing draw];
        [self.addingRing postDraw];
    }
}

- (void) handleTapOccurred:(TapEntity*)tap {
    
    
    
    // if tap was in block obstacle prototype
    if ([self.squarePrototype handleTap:tap]) {
        
        // Create new block obstacle obstacle at point
        BlockModel* sm = [[BlockModel alloc] initWithController:self.controller withAttributes:
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithFloat:self.addingRing.position->x], @"x",
                            [NSNumber numberWithFloat:self.addingRing.position->y], @"y", nil], @"initialPosition",
                           nil]];
        
    }
    else if ([self.shooterPrototype handleTap:tap]) {
        // Create new shooter at that point
        ShooterModel* sm = [[ShooterModel alloc] initWithController:self.controller withAttributes:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat:self.addingRing.position->x], @"x",
                              [NSNumber numberWithFloat:self.addingRing.position->y], @"y", nil], @"initialPosition",
                             nil]];
    }
    else if ([self.triPrototype handleTap:tap]) {
        // create new tri obstacle
        [[TriObstacleModel alloc] initWithController:self.controller withAttributes:[NSDictionary dictionaryWithKeysAndObjects:
                                                                                     @"initialPosition", [NSDictionary dictionaryWithKeysAndObjects:
                                                                                                          @"x", [NSNumber numberWithFloat:self.addingRing.position->x],
                                                                                                          @"y", [NSNumber numberWithFloat:self.addingRing.position->y], nil],
                                                                                     nil]];
    }
    else if ([self.blackholePrototype handleTap:tap]) {
        // create new blackhole
        [[BlackholeModel alloc] initWithController:self.controller withAttributes:[NSDictionary dictionaryWithKeysAndObjects:
                                                                                   @"initialPosition", [NSDictionary dictionaryWithKeysAndObjects:
                                                                                                        @"x", [NSNumber numberWithFloat:self.addingRing.position->x],
                                                                                                        @"y", [NSNumber numberWithFloat:self.addingRing.position->y], nil]
                                                                                   , nil]];
    }
}


@end
