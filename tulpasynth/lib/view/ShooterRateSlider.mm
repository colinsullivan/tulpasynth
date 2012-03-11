//
//  ShooterRateSlider.m
//  tulpasynth
//
//  Created by Colin Sullivan on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShooterRateSlider.h"

#import "tulpaViewController.h"

@implementation ShooterRateSlider

@synthesize active;

- (void) setPosition:(b2Vec2 *)aPosition {
    // Move menu to the left of the shooter
    aPosition->x -= 0.5;
    [super setPosition:aPosition];
}

- (void) setWidth:(float)width {
    // Menu is larger than shooter
    width *= 2.0;
    [super setWidth:width];
}
- (void) setHeight:(float)height {
    height *= 2.0;
    [super setHeight:height];
}

- (void) initialize {
    [super initialize];
    
    // initially hidden
    self.active = false;
    
    self.angle = 0.0;
    
    self.shape = new b2CircleShape();
    b2FixtureDef myShapeFixture;
    myShapeFixture.shape = self.shape;
    myShapeFixture.friction = 0.1f;
    myShapeFixture.density = 0.75f;
    myShapeFixture.restitution = 2.0f;
    
    self.shapeFixture = self.body->CreateFixture(&myShapeFixture);
    
    b2Filter filterData;
    filterData.groupIndex = 1;
    self.shapeFixture->SetFilterData(filterData);
}

- (void) dealloc {
    delete (b2CircleShape*)self.shape;
}

- (void) prepareToDraw {
    self.effect.texture2d0.name = self.controller.shooterRadialMenuBackground.name;
    
    [super prepareToDraw];
}

- (void) draw {
    if (self.active) {
        [super draw];
    }
}

@end
