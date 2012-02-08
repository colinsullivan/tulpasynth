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

#include "mo_touch.h"

#include "Globals.h"
#include "TouchEntity.h"

@interface tulpaViewController : GLKViewController {
    float _curRed;
    BOOL _increasing;
@private
    float _rotation;
}

@property (strong, nonatomic) EAGLContext * context;
@property (strong, nonatomic) GLKBaseEffect * effect;

void touch_callback( NSSet * touches, UIView * view, const std::vector<MoTouchTrack> & tracks, void * data);

@end
