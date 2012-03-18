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


@interface Toolbar : PhysicsEntity

//@property (nonatomic) b2MouseJoint* mouseJoint;

/**
 *  Wether or not the toolbox is completely closed (as in a drawer that is closed).
 **/
@property (nonatomic) BOOL closed;

/**
 *  Wether or not the toolbox is completely open.
 **/
@property (nonatomic) BOOL open;

//- (GLKMatrix4)currentModelViewTransform;
@end
