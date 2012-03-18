//
//  DragSelector.h
//  tulpasynth
//
//  Created by Colin Sullivan on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GLView.h"

@interface DragSelector : GLView

/**
 *  Start of drag in world coordinates
 **/
@property (nonatomic) b2Vec2 dragStart;

/**
 *  End of drag in world coordinates
 **/
@property (nonatomic) b2Vec2 dragEnd;


@end
