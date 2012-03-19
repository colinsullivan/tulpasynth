
//
//  Blackhole.m
//  tulpasynth
//
//  Created by Colin Sullivan on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Blackhole.h"

#import "tulpaViewController.h"

@implementation Blackhole

- (void) setWidth:(float)width {
    [super setWidth:width];
    
    self.shape->m_radius = self.width/2;
}

- (void) initialize {
    [super initialize];
    
    BlackholeModel* model = ((BlackholeModel*)self.model);
    
    
    
    self.shape = new b2CircleShape();
    self.width = [model.width floatValue];
    
    b2FixtureDef myShapeFixture;
    myShapeFixture.shape = self.shape;
    myShapeFixture.friction = 0.1f;
    myShapeFixture.density = 0.75f;
    myShapeFixture.restitution = 1.0f;
    self.shapeFixture = self.body->CreateFixture(&myShapeFixture);

    b2MassData myBodyMass;
    myBodyMass.mass = 0.25f;
    myBodyMass.center.SetZero();
    self.body->SetMassData(&myBodyMass);

    self.effect.texture2d0.name = self.controller.blackholeTexture.name;
    
//    instr = new instruments::RAMpler();
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"blackhole" ofType:@"wav"];
//    instr->set_clip([path UTF8String]);
//    instr->finish_initializing();
    
    for (int i = 0; i < 8; i++) {
        instruments::RAMpler* instr = new instruments::RAMpler();
        NSString* filename = [NSString stringWithFormat:@"blackhole_pitch_0%d", i];
        NSString* path = [[NSBundle mainBundle] pathForResource:filename ofType:@"wav"];
        instr->set_clip([path UTF8String]);
        instr->finish_initializing();
        instrs.push_back(instr);
    }

}

- (void) dealloc {
    delete (b2CircleShape*)self.shape;
}

- (void) handleCollision:(PhysicsEntity*)otherEntity withStrength:(float)collisionStrength; {
    
    if ([otherEntity class] == [WildBall class]) {
        WildBallModel* m = (WildBallModel*)otherEntity.model;
        instruments::RAMpler* instr = instrs[[m.pitchIndex intValue]];
        instr->reset();
        instr->play();
        // destroy ball model
//        NSLog(@"destroying model: %@", otherEntity.model);
        otherEntity.model.destroyed = [NSNumber numberWithBool:true];
//        [[Model Instances] removeObject:otherEntity.model];
//        // delete view
//        [self.controller.wildBalls removeObject:otherEntity];
//        [[PhysicsEntity Instances] removeObject:otherEntity];
    }
    
    
}

@end
