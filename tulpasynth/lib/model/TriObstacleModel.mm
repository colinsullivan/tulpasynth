//
//  TriObstacleModel.m
//  tulpasynth
//
//  Created by Colin Sullivan on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TriObstacleModel.h"

@implementation TriObstacleModel

+ (NSMutableDictionary*) defaultAttributes {
    NSMutableDictionary* defaults = [super defaultAttributes];
    
    [defaults setValue:[NSNumber numberWithFloat:4.75] forKey:@"width"];
    [defaults setValue:[NSNumber numberWithFloat:5] forKey:@"height"];
//    [defaults setValue:[NSNumber numberWithFloat:stk::PI/2.0] forKey:@"angle"];
    
    return defaults;
}

@end
