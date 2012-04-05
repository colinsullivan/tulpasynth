/**
 *  @file       ObstacleDeleteButton.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "ObstacleDeleteButton.h"

#import "tulpaViewController.h"

@implementation ObstacleDeleteButton

- (void) setPosition:(b2Vec2 *)aPosition {
    
    ObstacleModel* model = (ObstacleModel*)model;
    
    // position at the top right of the shooter
    aPosition->x += [model.width floatValue] + 3.0;
    aPosition->y += [model.height floatValue] + 4.0;
    
    [super setPosition:aPosition];
}

- (void) setWidth:(float)aWidth {
    [super setWidth:2.0];
}
- (void) setHeight:(float)aHeight {
    [super setHeight:2.0];
}

- (void) setAngle:(float32)anAngle {
    [super setAngle:0.0];
}

- (void) initialize {
    [super initialize];
    
    
    self.angle = 0.0;
    
    b2PolygonShape* myShape = new b2PolygonShape();
    self.width = 2.0;
    self.height = 2.0;
    myShape->SetAsBox(1.0, 1.0);
    
    self.shape = myShape;
    b2FixtureDef myShapeFixture;
    myShapeFixture.shape = self.shape;

    self.shapeFixture = self.body->CreateFixture(&myShapeFixture);
    
    b2Filter filterData;
    filterData.groupIndex = 1;
    self.shapeFixture->SetFilterData(filterData);
    
    self.effect.texture2d0.name = self.controller.deleteButtonTexture.name;
    self.color = self.controller.redColor;

}

-(void) dealloc {
    delete (b2PolygonShape*)self.shape;
}

- (void) handleTapOccurred:(TapEntity *)tap {
    // deselect obstacle
    [self.controller deselectAllObstacles];

    // delete model
    self.model.destroyed = [NSNumber numberWithBool:true];
}

+ (GLKBaseEffect*)effectInstance {
    static GLKBaseEffect* theInstance = nil;
    if (!theInstance) {
        theInstance = [[GLKBaseEffect alloc] init];
    }
    return theInstance;
}

+ (GLKBaseEffect*)effect1Instance {
    static GLKBaseEffect* theInstance = nil;
    if (!theInstance) {
        theInstance = [[GLKBaseEffect alloc] init];
    }
    return theInstance;
}

@end
