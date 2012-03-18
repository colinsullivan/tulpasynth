/**
 *  @file       PhysicsEntity.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#include "Globals.h"
#include "TapEntity.h"
#include "LongPressEntity.h"
#include "RotateEntity.h"
#include "PinchEntity.h"



#import "GLView.h"
#import "PhysicsEntityModel.h"

/**
 *  @class Base class for all graphics entities, all of which are subject
 *  to Box2D physics.
 **/
@interface PhysicsEntity : GLView


/**
 *  Callback used when model changes
 **/
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

@property b2Body* body;

/**
 *  Keep reference to outermost shape for border detection.
 **/
@property b2Shape* shape;
@property b2Fixture* shapeFixture;


- (void) initialize;
- (void)dealloc;

/**
 *  Static list of all physics entity instances.
 **/
+ (NSMutableArray*) Instances;

/**
 *  Static method for defining body type.  Should be overridden in child
 *  classes that wish to be dynamic bodies.
 **/
- (b2BodyType)bodyType;


/**
 *  Position of this object before panning started.
 **/
@property b2Vec2* prePanningPosition;


/**
 *  Handler for new tap as invoked by the view
 **/
- (GLboolean) handleTap:(TapEntity *) tap;
/**
 *  Handler for when tap occurs inside ourself.
 **/
- (void) handleTapOccurred:(TapEntity*)tap;


/**
 *  Wether or not this object responds to a long press gesture
 **/
@property (nonatomic) BOOL longPressable;
/**
 *  Handler for a long press gesture as invoked by the view.
 **/
- (GLboolean) handleLongPress:(LongPressEntity*)longPress;
/**
 *  Pointer to LongPressEntity that is currently "pressing" on self.
 **/
@property LongPressEntity* longPresser;
/**
 *  Handlers for when a long press on this entity have started, updated, 
 *  and ended.
 **/
- (void) handleLongPressStarted;
- (void) handleLongPressUpdated;
- (void) handleLongPressEnded;

/**
 *  Wether or not this object responds to a rotate gesture.
 **/
@property (nonatomic) BOOL rotateable;
/**
 *  Handler for a rotate gesture as invoked by the view.
 **/
- (GLboolean) handleRotate:(RotateEntity *) rotate;
/**
 *  The entity that is currently rotating this object.
 **/
@property RotateEntity * rotator;
/**
 *  Rotation value before gesture began
 **/
@property float32 preGestureAngle;
/**
 *  Handlers for when a rotate has started, updated, and ended.
 **/
- (void) handleRotateStarted;
- (void) handleRotateUpdated;
- (void) handleRotateEnded;


/**
 *  Wether or not this object responds to a pinch gesture
 **/
@property (nonatomic) BOOL pincheable;
/**
 *  The pinch gesture recognizer if this object is currently being pinched
 **/
@property PinchEntity * pincher;
/**
 *  Width and height properties for use when scaling (pinching)
 **/ 
@property GLfloat preScalingWidth, preScalingHeight;
/**
 *  handlePinch method as invoked by the view
 **/
- (GLboolean) handlePinch:(PinchEntity *) pinch;
/**
 *  Handlers for when a pinch has started, updated, and ended.
 **/
- (void) handlePinchStarted;
- (void) handlePinchUpdated;
- (void) handlePinchEnded;

/**
 *  Handle a collision with another entity
 **/
- (void) handleCollision:(PhysicsEntity*)otherEntity withStrength:(float)collisionStrength;

- (void) destroy;

@end
