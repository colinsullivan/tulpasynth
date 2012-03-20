//
//  WildBallModel.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WildBallModel.h"

@implementation WildBallModel

@synthesize initialLinearVelocity, pitchIndex, energy;

- (void) initialize {
    self.nosync = true;
    [super initialize];
}

- (NSMutableArray*) serializableAttributes {
    NSMutableArray* attributes = [super serializableAttributes];
    
//    [attributes removeObject:@"id"];
    
    [attributes addObject:@"initialLinearVelocity"];
    [attributes addObject:@"energy"];
    
    return attributes;
}

+ (NSMutableDictionary*) defaultAttributes {
    NSMutableDictionary* defaults = [super defaultAttributes];
    
    [defaults setValue:[NSNumber numberWithFloat:1.5] forKey:@"height"];
    [defaults setValue:[NSNumber numberWithFloat:1.5] forKey:@"width"];
    [defaults setValue:[NSNumber numberWithInt:-1] forKey:@"pitchIndex"];
    [defaults setValue:[NSNumber numberWithInt:8] forKey:@"energy"];
    
    return defaults;
}

@end
