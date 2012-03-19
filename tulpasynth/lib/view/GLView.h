//
//  GLView.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <GLKit/GLKit.h>

#import "View.h"

#include "b2Body.h"
#include "PanEntity.h"


#include "Globals.h"


/**
 *  @class  View class that takes care of generalized open gl drawing stuff.
 **/
@interface GLView : View {
    
@protected
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
}

@property (strong, nonatomic) GLKBaseEffect* effect;


/**
 *  Width and height of this object (in world coordinates)
 **/
@property float width;
@property float height;

/**
 *  Rotation of this object (in radians)
 **/
@property (nonatomic) float32 angle;

/**
 *  Position of the center of this object (in world coordinates)
 **/
@property (nonatomic) b2Vec2* position;


/**
 *  Wether or not this view will be drawn (TODO: this can invoke an animation
 *  when enabled/disabled).
 **/
@property (nonatomic) BOOL active;


/**
 *  Padding to add when scaling drawing.  Used to offset padding on texture
 *  images.
 **/
@property (nonatomic) float scalingMultiplier;

- (void) initialize;

- (void)prepareToDraw;
- (void)prepareToDraw1;
- (void)_bindAndEnable;
- (void)draw;
- (void)_disable;
- (void)postDraw;
- (void)postDraw1;

- (void)update;

/**
 *  Static list of all GLView instances
 **/
+ (NSMutableArray*) Instances;

/**
 *  Should be overridden in subclasses to create a transformation matrix used
 *  in `update`.
 **/
- (GLKMatrix4)currentModelViewTransform;

/**
 *  Handler for a pan (dragging) gesture.
 **/
- (GLboolean) handlePan:(PanEntity *) pan;
/**
 *  Handler for when a pan gesture involving this entity ended.
 **/
- (void) handlePanEnded;
/**
 *  Handler for when a pan gesture involving this entity has started.
 **/
- (void) handlePanStarted;
/**
 *  Handler for update when a pan gesture was active.
 **/
- (void) handlePanUpdate;
/**
 *  Pointer to pan gesture if it is currently happening on self
 **/
@property PanEntity * panner;

/**
 *  An optional secondary GLKBaseEffect for drawing two textures.
 **/
@property (strong, nonatomic) GLKBaseEffect* effect1;



@end
