//
//  tulpaViewController.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

#include <iostream>
#include <vector>

#import "mo_audio.h"
#include "b2World.h"
#include "b2Contact.h"
#include "b2WorldCallbacks.h"

#import "CollisionDetector.h"

#include "Globals.h"


#import "Instrument.hpp"

//#import "PhysicsEntity.h"

/**
 *  Global audio callback.  userData will be the `tulpaViewController` 
 *  instance.
 **/
void audioCallback(Float32 * buffer, UInt32 numFrames, void * userData);

@interface tulpaViewController : GLKViewController {
@private
    b2World* _world;
}

@property (strong) GLKTextureInfo* glowingCircleTexture;
@property (strong) GLKTextureInfo* glowingBoxTexture;

- (GLKTextureInfo*)loadTexture:(NSString*)imageFileName;

@property (strong, nonatomic) EAGLContext * context;
@property (strong, nonatomic) GLKBaseEffect * effect;

@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer * pinchRecognizer;
- (IBAction)pinchGestureHandler:(id)sender;

@property (strong, nonatomic) IBOutlet UIRotationGestureRecognizer * rotateRecognizer;
- (IBAction)rotateGestureHandler:(id)sender;

@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer * panRecognizer;
- (IBAction)panGestureHandler:(id)sender;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer * tapRecognizer;
- (IBAction)tapGestureHandler:(id)sender;

@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer * longPressRecognizer;
- (IBAction)longPressHandler:(id)sender;

@property (readonly) b2World* world;

/**
 *  This `CollisionDetector` instance will inform us when fixtures have 
 *  collided.
 **/
@property (readonly) CollisionDetector* collisionDetector;

/**
 *  Called from our `CollisionDetector` when two fixtures begin to touch.
 **/
- (void)beginCollision:(b2Contact*) contact;

- (b2World*)getWorld;
- (b2World*)world;

/**
 *  The list of obstacle objects currently in creation.
 **/
@property (strong, nonatomic) NSMutableArray * obstacles;

/**
 *  The list of falling balls that are currently instantiated.
 **/
@property (strong, nonatomic) NSMutableArray * fallingBalls;

/**
 *  Mapping of `b2Body` instances to `PhysicsEntity` (or subclass) instances.
 **/
//@property (strong, nonatomic) NSMapTable* bodyToEntityMap;

- (GLuint)setupTexture:(NSString *)fileName;
- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType;

@end
