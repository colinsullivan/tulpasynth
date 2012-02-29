//
//  WildBallModel.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WildBallModel.h"

@implementation WildBallModel

@synthesize initialLinearVelocity;

- (NSMutableArray*) serializableAttributes {
    NSMutableArray* attributes = [super serializableAttributes];
    
    [attributes addObject:@"initialLinearVelocity"];
    
    return attributes;
}

- (void) initialize {
    [super initialize];
    
    if (!self.height || !self.width) {
        self.height = [NSNumber numberWithFloat:2.0];
        self.width = [NSNumber numberWithFloat:2.0];
    }    
}

@end
