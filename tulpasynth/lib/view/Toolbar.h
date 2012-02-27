//
//  Toolbar.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GLView.h"

@interface Toolbar : GLView

- (void) initialize;

- (GLKMatrix4)currentModelViewTransform;
@end
