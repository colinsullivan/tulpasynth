//
//  DragSelector.h
//  tulpasynth
//
//  Created by Colin Sullivan on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GLView.h"

#include "b2PolygonShape.h"

@interface DragSelector : GLView

/**
 *  Start of drag in world coordinates
 **/
@property (nonatomic) b2Vec2 dragStart;

/**
 *  End of drag in world coordinates
 **/
@property (nonatomic) b2Vec2 dragEnd;

/**
 *  a shape corresponding to the shape of the highlight.
 **/
@property (nonatomic) b2PolygonShape* shape;


@end
