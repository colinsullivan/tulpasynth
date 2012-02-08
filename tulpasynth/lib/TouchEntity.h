//
//  TouchEntity.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GfxEntity.h"

//@interface TouchEntity : GfxEntity
//
//@property GLboolean active;
//@property (strong) UITouch* touch_ref;
//
//@end


class TouchEntity {
public:
    TouchEntity();
    ~TouchEntity();

    Vector3D * position;
    GLboolean active;
    UITouch* touch_ref;
};