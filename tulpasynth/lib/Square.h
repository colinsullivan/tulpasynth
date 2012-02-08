//
//  Square.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>

#include "mo_gfx.h"
#include "Globals.h"

@interface Square : NSObject

- (id)init;
- (void)dealloc;
- (void)draw;
- (void)update;

@property (strong, nonatomic) GLKBaseEffect * effect;
@property (nonatomic) GLfloat width;
@property (nonatomic) GLfloat height;
@property (nonatomic) Vector3D* position;

@end
