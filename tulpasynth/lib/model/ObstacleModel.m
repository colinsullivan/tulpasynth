//
//  ObstacleModel.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObstacleModel.h"

@implementation ObstacleModel

@synthesize position, angle;

- (NSMutableArray*) serializableAttributes {
    NSMutableArray* attributes = [super serializableAttributes];

    [attributes addObject:@"position"];
    [attributes addObject:@"angle"];
    
    return attributes;
}

@end
