//
//  Square.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "GfxEntity.h"

#include "TouchEntity.h"

@interface Square : GfxEntity

- (GLboolean) handleTouch:(TouchEntity *) touch;

// The touch entity that is currently dragging this object
@property TouchEntity * dragger;

@end
