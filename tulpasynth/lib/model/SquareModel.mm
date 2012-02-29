//
//  SquareModel.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SquareModel.h"

@implementation SquareModel

- (void) initialize {
    [super initialize];    
}

+ (NSMutableDictionary*) defaultAttributes {
    NSMutableDictionary* defaults = [super defaultAttributes];
    
    [defaults setValue:[NSNumber numberWithFloat:6.0] forKey:@"width"];
    [defaults setValue:[NSNumber numberWithFloat:3.0] forKey:@"height"];
    
    return defaults;
}

@end
