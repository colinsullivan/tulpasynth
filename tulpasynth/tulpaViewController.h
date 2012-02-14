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

#include <iostream>
#include <vector>

#import "mo_audio.h"
#include "b2World.h"

#include "Globals.h"

#import "Instrument.hpp"

//#import "PhysicsEntity.h"

/**
 *  Global audio callback.  userData will be the `tulpaViewController` 
 *  instance.
 **/
void audioCallback(Float32 * buffer, UInt32 numFrames, void * userData);

@interface tulpaViewController : GLKViewController {
    /**
     *  The list of instrument instances whose audio will be rendered.
     **/
    std::vector<instruments::Instrument*> instrs;
@private
    b2World* _world;
}

@property (strong) GLKTextureInfo* glowingCircleTexture;

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

@property (readonly) b2World* world;

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


- (GLuint)setupTexture:(NSString *)fileName;
- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType;

@end
