//
//  GfxEntity.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>

#import "tulpaViewController.h"

#include "mo_gfx.h"
#include "Globals.h"

@interface GfxEntity : NSObject {

@protected
    GLuint _vertexBuffer;
    GLuint _indexBuffer;

}

- (id)init;
- (id)initWithViewController:(tulpaViewController *)controller;
- (void)dealloc;
- (void)draw;
- (void)update;

@property (strong, nonatomic) GLKBaseEffect * effect;
@property (nonatomic) GLfloat width;
@property (nonatomic) GLfloat height;
@property (nonatomic) Vector3D* position;

@property (nonatomic) tulpaViewController* controller;

/**
 *  Current rotation of object (in radians)
 **/
@property GLfloat rotation;

/**
 *  Rotation value before rotation gesture.
 **/
@property GLfloat preGestureRotation;

@end
