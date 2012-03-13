/**
 *  @file       Square.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "Square.h"

#import "tulpaViewController.h"

@implementation Square

@synthesize instr;

- (void)setHeight:(float)height {
    [super setHeight:height];
    
    [self resize];
}

- (void)setWidth:(float)width {
    [super setWidth:width];
    
    [self resize];
}


/**
 *  When width or height is set, change shape.
 **/
- (void)resize {
    if (self.shapeFixture) {
        self.body->DestroyFixture(self.shapeFixture);        
    }
    
    if (self.shape) {
        delete (b2PolygonShape*)self.shape;
    }
    
    self.shape = new b2PolygonShape();
    self.shape->m_radius = 0.5f;
    ((b2PolygonShape*)self.shape)->SetAsBox(
                                            self.width/2.0 - 0.5,
                                            self.height/2.0 - 0.5
                                            );
    
    b2FixtureDef mySquareFixture;
    mySquareFixture.shape = self.shape;
    mySquareFixture.density = 1.0f;
    mySquareFixture.friction = 0.1f;
    mySquareFixture.restitution = 1.5f;
    
    self.shapeFixture = self.body->CreateFixture(&mySquareFixture);
}

- (void) initialize {

    [super initialize];

    b2MassData myBodyMass;
    myBodyMass.mass = 10.0f;
    self.body->SetMassData(&myBodyMass);
    
    self.instr = new instruments::FMPercussion();
    self.instr->finish_initializing();
    
}

- (void) dealloc {
    delete (instruments::FMPercussion*)self.instr;
    
//    [super dealloc];
}

-(void)prepareToDraw {
    self.effect.useConstantColor = YES;
    self.effect.constantColor = self.controller.greenColor;
    self.effect.texture2d0.name = self.controller.glowingBoxTexture.name;
    
    [super prepareToDraw];
}

- (void) handleCollision:(float)collisionStrength {

        self.instr->freq((5/self.width) * 1320);
        self.instr->velocity(collisionStrength);
        self.instr->play();
}

//- (void)update {
//    [super update];
//
//}

@end
