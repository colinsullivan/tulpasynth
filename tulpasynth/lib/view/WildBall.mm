//
//  WildBall.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WildBall.h"

#import "tulpaViewController.h"

@implementation WildBall

- (void) setWidth:(float)width {
    [super setWidth:width];
    
    self.shape->m_radius = self.width/2;
}

- (void) initialize {
    [super initialize];
    
    WildBallModel* model = ((WildBallModel*)self.model);
    
    // Create circle shape
    self.shape = new b2CircleShape();
    self.width = [model.width floatValue];
    
    b2FixtureDef myShapeFixture;
    myShapeFixture.shape = self.shape;
    myShapeFixture.friction = 0.1f;
    myShapeFixture.density = 0.33f;
    myShapeFixture.restitution = 1.25f;
    
    self.shapeFixture = self.body->CreateFixture(&myShapeFixture);
    
    b2MassData myBodyMass;
    myBodyMass.mass = 2.00f;
    myBodyMass.center.SetZero();
    self.body->SetMassData(&myBodyMass);
    
    self.body->SetLinearVelocity(
                                 b2Vec2(
                                        [[model.initialLinearVelocity valueForKey:@"x"] floatValue], 
                                        [[model.initialLinearVelocity valueForKey:@"y"] floatValue]
                                        )
                                 );
    
    self.color = GLKVector4Make(0, 0.5, 0.5, 1.0);
    self.effect.texture2d0.name = self.controller.wildBallTexture.name;
    
    self.effect1.texture2d0.enabled = GL_TRUE;
    self.effect1.texture2d0.name = self.controller.wildBallGlowTexture.name;
    self.effect1.useConstantColor = YES;
    

}

- (b2BodyType)bodyType {
    return b2_dynamicBody;
}

- (void) destroy {
    
    // remove shape and body from physics world
    delete ((b2CircleShape*)(self.shape));
    self.body->DestroyFixture(self.shapeFixture);
    
    [super destroy];
}

- (void) update {
    if (self.active) {
        [super update];
    }
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    WildBallModel* m = (WildBallModel*)self.model;
    // when energy amount changes
    if ([keyPath isEqualToString:@"energy"]) {
        // change glowing-ness
        
        // update glow effect accordingly
        float energyPerc = [m.energy floatValue] / [[[WildBallModel defaultAttributes] valueForKey:@"energy"] floatValue];
        self.effect1.constantColor = GLKVector4Make(
                                                    self.color.r * energyPerc, 
                                                    self.color.g * energyPerc, 
                                                    self.color.b * energyPerc, 
                                                    1.0);
    }
}



- (void) handleCollision:(PhysicsEntity *)otherEntity withStrength:(float)collisionStrength {
    [super handleCollision:otherEntity withStrength:collisionStrength];
    
    // subtract from ball's energy
    WildBallModel* m = (WildBallModel*)self.model;
    
    m.energy = [NSNumber numberWithInt:[m.energy intValue]-1];
    
    if ([m.energy intValue] == 0) {
        // ball should die
        m.destroyed = [NSNumber numberWithBool:true];
    }
}
@end
