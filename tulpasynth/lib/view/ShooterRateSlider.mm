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

@synthesize active, arrow;

- (void) setPosition:(b2Vec2 *)aPosition {
    // Move menu behind the shooter
//    aPosition->x -= 0.5;
    aPosition->x -= 0.5 * cosf(self.angle);
    aPosition->y -= 0.5 * sinf(self.angle);
    [super setPosition:aPosition];
}

- (void) setWidth:(float)aWidth {
    // Menu is larger than shooter
    aWidth *= 2.0;
    self.shape->m_radius = aWidth/2.0;
    [super setWidth:aWidth];
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
    
    self.effect.texture2d0.name = self.controller.shooterRadialMenuBackground.name;
    
    arrow = [[ShooterRateSliderArrow alloc] initWithController:self.controller withModel:self.model withShooterRateSlider:self];
}

- (void) dealloc {
    delete (b2CircleShape*)self.shape;
}


- (void) draw {
    if (self.active) {
        [super draw];
    }
}

- (void) postDraw {
    if (self.active) {
        [super postDraw];
        
        [arrow prepareToDraw];
        [arrow draw];
        [arrow postDraw];
    }
}

- (void) update {
    [super update];
    
    [arrow update];
}

@end
