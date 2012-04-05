/**
 *  @file       PolygonObstacle.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "PolygonObstacle.h"

@implementation PolygonObstacle

- (void) initialize {
    [super initialize];

    self.shape = new b2PolygonShape();
}

- (void)setHeight:(float)height {
    [super setHeight:height];
    
    [self createShape];
}

- (void)setWidth:(float)width {
    [super setWidth:width];
    
    [self createShape];
}

- (void)setWidth:(float)aWidth withHeight:(float)aHeight {
    super.width = aWidth;
    super.height = aHeight;
    
    [self createShape];
}

- (void) destroyShape {
    if (self.shapeFixture) {
        self.body->DestroyFixture(self.shapeFixture);        
    }
    
}

- (void) createShape {
    [self destroyShape];
}

- (void) dealloc {
    delete (b2PolygonShape*)self.shape;
}

@end
