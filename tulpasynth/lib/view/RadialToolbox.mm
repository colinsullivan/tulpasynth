//
//  RadialToolbox.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RadialToolbox.h"

#import "tulpaViewController.h"

@implementation RadialToolbox

@synthesize active;

- (void) setWidth:(float)width {
    [super setWidth:width];
    
    self.shape->m_radius = self.width/2;
}

- (void) initialize {
    
    [super initialize];
        
    self.angle = 0.0;
    
    self.active = false;
    
    self.position = b2Vec2(20, 10);
    
    self.shape = new b2CircleShape();
    b2FixtureDef myShapeFixture;
    myShapeFixture.shape = self.shape;
    myShapeFixture.friction = 0.1f;
    myShapeFixture.density = 0.75f;
    myShapeFixture.restitution = 2.0f;
    
    self.shapeFixture = self.body->CreateFixture(&myShapeFixture);
    
    self.width = 30;
    self.height = 30;
    
    b2Filter filterData;
    filterData.groupIndex = 1;
    self.shapeFixture->SetFilterData(filterData);
}

- (void) dealloc {
    [self dealloc];
    delete self.shape;
}

-(void)prepareToDraw {
    self.effect.useConstantColor = YES;
    self.effect.constantColor = GLKVector4Make(0.15, 0.88, 0.49, 1.0);
    self.effect.texture2d0.name = self.controller.toolboxTexture.name;
    
    [super prepareToDraw];
}

- (void) draw {
    if (self.active) {
        [super draw];
    }
}

@end
