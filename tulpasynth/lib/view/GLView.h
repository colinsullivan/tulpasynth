//
//  GLView.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <GLKit/GLKit.h>

#import "View.h"

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

- (void) initialize;

- (void)prepareToDraw;
- (void)draw;
- (void)postDraw;

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

@end
