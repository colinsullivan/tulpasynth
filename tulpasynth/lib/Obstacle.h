//
//  Obstacle.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhysicsEntity.h"

#include "b2Math.h"

#include "TouchEntity.h"
#include "PinchEntity.h"
#include "RotateEntity.h"
#include "PanEntity.h"
#include "TapEntity.h"

@interface Obstacle : PhysicsEntity

- (GLboolean) handlePinch:(PinchEntity *) pinch;

/**
 *  Called from parent view from rotate gesture callback.
 **/
- (GLboolean) handleRotate:(RotateEntity *) rotate;

/**
 *  The entity that is currently rotating this object.
 **/
@property RotateEntity * rotator;

- (GLboolean) _touchIsInside:(TouchEntity *)touch;
- (GLboolean) _touchIsInside:(TouchEntity *)touch withFudge:(float)fudgeFactor;

// The pinch gesture recognizer if this object is currently being pinched
@property PinchEntity * pincher;

/**
 *  Width and height properties for use when scaling (pinching)
 **/ 
@property GLfloat beforeScalingWidth;
@property GLfloat beforeScalingHeight;

/**
 *  Handler for a pan (dragging) gesture.
 **/
- (GLboolean) handlePan:(PanEntity *) pan;
@property PanEntity * panner;
@property b2Vec2* prePanningPosition;

- (GLboolean) handleTap:(TapEntity *) tap;

@end
