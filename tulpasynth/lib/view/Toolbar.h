//
//  Toolbar.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "b2PolygonShape.h"
#include "b2MouseJoint.h"

#import "PhysicsEntity.h"


@interface Toolbar : PhysicsEntity {
    b2Vec2 offsetPosition;
}

@property (nonatomic) b2MouseJoint* mouseJoint;

- (void) initialize;
- (b2BodyType) bodyType;
-(void)prepareToDraw;
- (void) update;

//- (GLKMatrix4)currentModelViewTransform;
@end
