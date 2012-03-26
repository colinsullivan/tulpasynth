/**
 *  @file       ShooterRateSliderArrow.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "ShooterRateSliderArrow.h"

#import "tulpaViewController.h"

#import "ShooterRateSlider.h"

@implementation ShooterRateSliderArrow

@synthesize slider;

- (void) setPosition:(b2Vec2 *)aPosition {
    
    // fudge factor because the "slider" graphic fades out before 180°
    static float radianFudge = 0.5;
    
    float minRadians = self.slider.angle + -stk::PI/2.0 + radianFudge;
    float maxRadians = self.slider.angle + stk::PI/2.0 - radianFudge;
    float rangeRadians = maxRadians - minRadians;
    
    static float rangeSliderValues = [[ShooterModel maxRate] floatValue] - [[ShooterModel minRate] floatValue];
    
    // map range of slider values into range of radians
    static float radianPerSliderValue = rangeRadians / rangeSliderValues;
    
    ShooterModel* model = ((ShooterModel*)self.model);

    // map rate to a radian value
    float positionRadians = [model.rate floatValue] * radianPerSliderValue;
    
    aPosition->x -= cosf(minRadians + positionRadians)*(self.slider.width/2.0 + 1);
    aPosition->y += sinf(minRadians + positionRadians)*(self.slider.width/2.0 + 1);
    
    // orientation
//    self.angle = stk::PI/2.0 + stk::PI/4.0 + [model.rate floatValue]*(stk::PI/rangeSliderValues);
    super.angle = self.slider.angle + stk::PI + positionRadians - radianFudge/2.0;
    
    [super setPosition:aPosition];
}

- (void) setWidth:(float)aWidth {
    return;
}
- (void) setHeight:(float)aHeight {
    return;
}
- (void) setAngle:(float32)anAngle {
    return;
}

- (BOOL)active {
    //active value slaved from slider
    return self.slider.active;
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
    
//    if (self.slider.position) {
//        self.position = self.model.;
//    }
}

- (void) dealloc {
    delete (b2PolygonShape*)self.shape;
}


- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    ShooterModel* model = ((ShooterModel*)self.model);
    
    if ([keyPath isEqualToString:@"rate"]) {
//        if (self.slider.position) {
//            self.position = self.slider.position;
//        }
        self.position = new b2Vec2([[model.position valueForKey:@"x"] floatValue], [[model.position valueForKey:@"y"] floatValue]);
    }
}

//- (GLKMatrix4)currentModelViewTransform {
//    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
//    
//    // frst translate and rotate to slider position
////    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, M_TO_PX(self.slider.position->y), M_TO_PX(self.slider.position->x), 0.0);
//    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, self.slider.angle, 0.0, 0.0, 1.0);
//    
//    // then to ours
//    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, M_TO_PX(self.position->y), M_TO_PX(self.position->x), 0.0);
//    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, self.angle, 0.0, 0.0, 1.0);
//    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, M_TO_PX(self.height/2), M_TO_PX(self.width/2), 1.0f);
//    
//    return modelViewMatrix;
//}

- (void) handlePanStarted {
    self.slider.panner = self.panner;
    return [self.slider handlePanStarted];
}
- (void) handlePanUpdate {
    self.slider.panner = self.panner;
    return [self.slider handlePanUpdate];
}
- (void) handlePanEnded {
    [self.slider handlePanEnded];
    self.slider.panner = nil;
}

@end
