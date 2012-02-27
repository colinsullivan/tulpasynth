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
        delete self.shape;
    }
    
    self.shape = new b2PolygonShape();
    self.shape->m_radius = 1.0f;
    ((b2PolygonShape*)self.shape)->SetAsBox(self.width/2 - (self.width/15), self.height/2 - (self.height/15));
    
    b2FixtureDef mySquareFixture;
    mySquareFixture.shape = self.shape;
    mySquareFixture.density = 1.0f;
    mySquareFixture.friction = 0.1f;
    mySquareFixture.restitution = 0.75f;
    
    self.shapeFixture = self.body->CreateFixture(&mySquareFixture);
}

- (void) initialize {

    [super initialize];

    b2MassData myBodyMass;
    myBodyMass.mass = 10.0f;
    self.body->SetMassData(&myBodyMass);
    
    self.instr = new instruments::FMPercussion();
    
}

- (void) dealloc {
    delete self.instr;
    
    [super dealloc];
}

-(void)prepareToDraw {
    self.effect.useConstantColor = YES;
    self.effect.constantColor = GLKVector4Make(0.15, 0.88, 0.49, 1.0);
    self.effect.texture2d0.name = self.controller.glowingBoxTexture.name;
    
    [super prepareToDraw];
}

//- (void)update {
//    [super update];
//
//}

@end
