/**
 *  @file       FallingBallModel.m
 *              tulpasynth
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "FallingBallModel.h"

@implementation FallingBallModel

@synthesize initialPosition;

- (id) initWithPosition:(NSDictionary*)aPosition {
    if (self = [super init]) {
        self.initialPosition = aPosition;
    }
    
    return self;
}

- (NSMutableArray*) serializableAttributes {
    NSMutableArray* attributes = [super serializableAttributes];
    
    [attributes addObject:@"initialPosition"];
    
    return attributes;
}


@end
