//
//  Square.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "GfxEntity.h"

#include "TouchEntity.h"
#include "PinchEntity.h"

@interface Square : GfxEntity

- (GLboolean) handleTouch:(TouchEntity *) touch;
- (GLboolean) handlePinch:(PinchEntity *) pinch;

- (GLboolean) _touchIsInside:(TouchEntity *)touch;
- (GLboolean) _touchIsInside:(TouchEntity *)touch withFudge:(float)fudgeFactor;

// The touch entity that is currently dragging this object
@property TouchEntity * dragger;

// The pinch gesture recognizer if this object is currently being pinched
@property PinchEntity * pincher;

/**
 *  Width and height properties for use when scaling (pinching)
 **/ 
@property GLfloat beforeScalingWidth;
@property GLfloat beforeScalingHeight;

@end
