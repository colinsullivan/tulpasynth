//
//  TouchEntity.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "b2Math.h"

//#import "GfxEntity.h"

//@interface TouchEntity : GfxEntity
//
//@property GLboolean active;
//@property (strong) UITouch* touch_ref;
//
//@end

#ifndef _TOUCHENTITY_H_
#define _TOUCHENTITY_H_

class TouchEntity {
public:
    TouchEntity();
    ~TouchEntity();

    b2Vec2 * position;
    GLboolean active;
    UITouch* touch_ref;
};

#endif