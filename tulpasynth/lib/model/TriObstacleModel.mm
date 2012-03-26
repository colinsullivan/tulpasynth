/**
 *  @file       TriObstacleModel.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

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
