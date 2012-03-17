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

@synthesize active, arrow, rateBeforeSliding;

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

- (GLboolean) handlePan:(PanEntity *)pan {
    // if pan didn't end up in this shape, see if it worked in arrow.
    if(![super handlePan:pan]) {
        if ([arrow handlePan:pan]) {
            return true;
        }
    }
    
    return false;
}

- (void) handlePanStarted {
    ShooterModel* model = ((ShooterModel*)self.model);

    model.ignoreUpdates = true;
    rateBeforeSliding = model.rate;    
}

- (void) handlePanUpdate {
    b2Vec2 newPos = (*self.prePanningPosition) + self.panner->translation;
    
    static float rateScalar = 0.3;
    
    ShooterModel* model = ((ShooterModel*)self.model);
    float newRate = [rateBeforeSliding floatValue] + (rateScalar*-sinf(self.angle)*self.panner->translation.y) + (rateScalar*-cosf(self.angle)*self.panner->translation.x);
    model.rate = [NSNumber numberWithFloat:newRate];
    [model generateNewShotTimes];
}

- (void) handlePanEnded {
    ShooterModel* model = ((ShooterModel*)self.model);
    // TODO: synchronization race condition here.  ignoreUpdates should be
    // turned off in callback
    [model synchronize];
    
    model.ignoreUpdates = false;
}

@end
