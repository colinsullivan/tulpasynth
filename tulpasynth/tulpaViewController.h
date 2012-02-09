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

#include "b2World.h"

#include "b2Body.h"
#include "b2PolygonShape.h"
#include "b2Fixture.h"

#include "Globals.h"

@interface tulpaViewController : GLKViewController {
    float _curRed;
    BOOL _increasing;
@private
    float _rotation;
}

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

@property (nonatomic) b2World * world;

@end
