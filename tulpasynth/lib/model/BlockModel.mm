//
//  BlockModel.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BlockModel.h"

@implementation BlockModel

static float minWidth = 6.0;
static float maxWidth = 50.0;

// ensure width and height are within bounds
- (void)setWidth:(NSNumber *)aWidth {
    
    float value = [aWidth floatValue];
    
    if (value < minWidth) {
        aWidth = [NSNumber numberWithFloat:minWidth];
    }
    else if (value > maxWidth) {
        aWidth = [NSNumber numberWithFloat:maxWidth];
    }
    
    [super setWidth:aWidth];
}

- (void)setHeight:(NSNumber *)aHeight {
    
    float value = [aHeight floatValue];
    
    if (value < minWidth/2.0) {
        aHeight = [NSNumber numberWithFloat:minWidth/2.0];
    }
    else if (value > maxWidth/2.0) {
        aHeight = [NSNumber numberWithFloat:maxWidth/2.0];
    }
    
    [super setHeight:aHeight];
}

//+ (NSMutableDictionary*) constraints {
//    NSMutableDictionary* theConstraints = [super constraints];
//    
//    [theConstraints setValue:[NSDictionary dictionaryWithKeysAndObjects:
//                              @"min", [NSNumber numberWithFloat:6.0],
//                              @"max", [NSNumber numberWithFloat:100.0],
//                              nil] forKey:@"width"];
//    // height should be width/2
//    [theConstraints setValue:[NSDictionary dictionaryWithKeysAndObjects:
//                              @"min", [NSNumber numberWithFloat:0.5 * [[[theConstraints valueForKey:@"width"] valueForKey:@"min"] floatValue]],
//                              @"max", [NSNumber numberWithFloat:0.5 * [[[theConstraints valueForKey:@"width"] valueForKey:@"max"] floatValue]],
//                              nil] forKey:@"height"];
//    
//    return theConstraints;
//}

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