//
//  ShooterRateSliderArrow.m
//  tulpasynth
//
//  Created by Colin Sullivan on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShooterRateSliderArrow.h"

#import "tulpaViewController.h"

#import "ShooterRateSlider.h"

@implementation ShooterRateSliderArrow

@synthesize slider;

- (void) setPosition:(b2Vec2 *)aPosition {
    
    // fudge factor because the "slider" graphic fades out before 180°
    static float radianFudge = 0.5;
    
    static float minRadians = -stk::PI/2.0 + radianFudge;
    static float maxRadians = stk::PI/2.0 - radianFudge;
    static float rangeRadians = maxRadians - minRadians;
    
    static float rangeSliderValues = [[ShooterModel maxRate] floatValue] - [[ShooterModel minRate] floatValue];
    
    // map range of slider values into range of radians
    static float radianPerSliderValue = rangeRadians / rangeSliderValues;
    
    ShooterModel* model = ((ShooterModel*)self.model);

    // map rate to a radian value
    float positionRadians = [model.rate floatValue] * radianPerSliderValue;
    
    aPosition->x -= cosf(minRadians + positionRadians)*(self.slider.width/2.0);
    aPosition->y += sinf(minRadians + positionRadians)*(self.slider.width/2.0);
    
    // orientation
//    self.angle = stk::PI/2.0 + stk::PI/4.0 + [model.rate floatValue]*(stk::PI/rangeSliderValues);
    self.angle = stk::PI + positionRadians - radianFudge;
    
    [super setPosition:aPosition];
}

- (void) setWidth:(float)aWidth {
    return;
}
- (void) setHeight:(float)aHeight {
    return;
}

- (id)initWithController:(tulpaViewController *)theController withModel:(Model *)aModel withShooterRateSlider:(ShooterRateSlider*)aSlider {
    if (self = [super initWithController:theController withModel:aModel]) {
        self.slider = aSlider;
    }
    
    return self;
}

- (void) initialize {
    [super initialize];
    
    b2PolygonShape* myShape = new b2PolygonShape();
    super.width = 2.0;
    super.height = 2.0;
    myShape->SetAsBox(self.width, self.height);
    
    self.shape = myShape;
    b2FixtureDef myShapeFixture;
    myShapeFixture.shape = self.shape;
    myShapeFixture.friction = 0.1f;
    myShapeFixture.density = 0.75f;
    myShapeFixture.restitution = 2.0f;
    
    self.shapeFixture = self.body->CreateFixture(&myShapeFixture);
    
    b2Filter filterData;
    filterData.groupIndex = 1;
    self.shapeFixture->SetFilterData(filterData);
    
    self.effect.texture2d0.name = self.controller.shooterRadialMenuPointer.name;
    
    if (self.slider.position) {
        self.position = self.slider.position;
    }
}

- (void) draw {
    if (self.slider.active) {
        [super draw];
    }
}

- (void) postDraw {
    if (self.slider.active) {
        [super postDraw];
    }
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if ([keyPath isEqualToString:@"rate"]) {
        if (self.slider.position) {
            self.position = self.slider.position;
        }
    }
}
@end
