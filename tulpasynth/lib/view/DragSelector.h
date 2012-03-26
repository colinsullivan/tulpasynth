/**
 *  @file       DragSelector.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

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
