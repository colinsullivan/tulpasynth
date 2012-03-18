//
//  Toolbar.mm
//  tulpasynth
//
//  Created by Colin Sullivan on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Toolbar.h"

#import "tulpaViewController.h"

@implementation Toolbar

@synthesize closed, open;

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
    closedPosition.Set(-self.width/2.0 + 0.75, self.height/2.0);
    
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
    
    [super setPosition:aPosition];
}

- (void) initialize {
    [super initialize];
    
    self.pannable = true;
    
    self.width = PX_TO_M(768);
    self.height = PX_TO_M(768);
    
    self.angle = 0.0;

    self.position = new b2Vec2(-self.width/2.0 + 0.75, self.height/2.0);
    
    self.shape = new b2PolygonShape();
    self.shape->m_radius = 1.0f;
    ((b2PolygonShape*)self.shape)->SetAsBox(self.width/2.0, self.height/2.0);
    
    b2FixtureDef mySquareFixture;
    mySquareFixture.shape = self.shape;    
    self.shapeFixture = self.body->CreateFixture(&mySquareFixture);
    
    b2Filter filterData;
    filterData.groupIndex = 2;
    self.shapeFixture->SetFilterData(filterData);
    
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

}

- (b2BodyType) bodyType {
    return b2_dynamicBody;
}

- (GLboolean) handlePan:(PanEntity *)pan {
    // if toolbox is closed
    if (self.closed) {
        // catch pan gestures that start towards the left side of screen
        if (pan->state == GestureEntityStateStart) {
            if (pan->touches[0]->position->x < 8.0) {
                self.panner = pan;
                [self handlePanStarted];
                return true;
            }
        }
//        // continue pan gestures
//        else if (pan->state == GestureEntityStateUpdate && self.panner == pan) {
//            return [super handlePan:pan];
//        }
//        else if (pan->state == GestureEntityStateEnd && self.panner == pan) {
//            return [super handlePan:pan];
//        }
    }
    else {
        return [super handlePan:pan];
    }
    
    return false;
}

- (void) update {
    [super update];
    
    // Keep position up to date
    b2Transform currentTransform = self.body->GetTransform();
    self.position = &currentTransform.p;
    
}


- (void) handlePanStarted {
    [super handlePanStarted];
    self.body->SetLinearVelocity(b2Vec2(0.0, 0.0));
    self.closed = false;
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


@end
