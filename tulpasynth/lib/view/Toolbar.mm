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

@synthesize mouseJoint;

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

- (void) setPosition:(const b2Vec2 &)aPosition {
    offsetPosition = aPosition;
    // max position
    if (offsetPosition.x < 0) {
        offsetPosition.x = 0;
    }
    
    if (offsetPosition.x > -10.0 + self.width + self.width/2.0) {
        offsetPosition.x = -10.0 + self.width + self.width/2.0;
    }
    
    [super setPosition:offsetPosition];
}

- (void) initialize {
    [super initialize];
    
    self.pannable = true;
    
    self.width = PX_TO_M(self.controller.view.frame.size.height);
    self.height = PX_TO_M(self.controller.view.frame.size.width);
    
    self.angle = 0.0;
    
    self.position = b2Vec2(-10.0 + self.width + self.width/2.0, self.height/2.0);
    
    self.shape = new b2PolygonShape();
    self.shape->m_radius = 1.0f;
    ((b2PolygonShape*)self.shape)->SetAsBox(self.width/2.0, self.height/2.0);
    
    b2FixtureDef mySquareFixture;
    mySquareFixture.shape = self.shape;    
    self.shapeFixture = self.body->CreateFixture(&mySquareFixture);
    
    b2Filter filterData;
    filterData.groupIndex = 1;
    self.shapeFixture->SetFilterData(filterData);
    
//    b2MassData myBodyMass;
//    myBodyMass.mass = 1.0f;
//    self.body->SetMassData(&myBodyMass);

    
    self.body->SetGravityScale(0.0);
    
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
}

- (b2BodyType) bodyType {
    return b2_dynamicBody;
}

-(void)prepareToDraw {
    self.effect.texture2d0.name = self.controller.toolbarTexture.name;
    
    [super prepareToDraw];
}


- (void) update {
    [super update];
    
    if (self.panner) {
        b2Vec2 newPos = (*self.prePanningPosition);
        newPos.x += self.panner->translation.x;
        self.position = newPos;
        
    }

    NSLog(@"self.body->GetLinearVelocity(): %f", self.body->GetLinearVelocity().x);
}

- (void) handlePanStarted {
    [super handlePanStarted];
    self.body->SetLinearVelocity(b2Vec2(0.0, 0.0));
}

- (void) handlePanEnded {
    [super handlePanEnded];
    NSLog(@"self.panner->velocity.x: %f", self.panner->velocity.x);
//    self.body->SetLinearVelocity(b2Vec2(self.panner->velocity.x, 0));
//    self.body->ApplyForceToCenter(b2Vec2(self.panner->velocity.x, 0.0));
    self.body->ApplyLinearImpulse(b2Vec2(self.panner->velocity.x, 0.0), self.position);
}


@end
