//
//  Square.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "b2PolygonShape.h"

#import "Obstacle.h"


@interface Square : Obstacle

//@property b2PolygonShape* square;

@property float width;
@property float height;

@end
