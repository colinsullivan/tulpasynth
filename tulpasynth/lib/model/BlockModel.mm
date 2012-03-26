/**
 *  @file       BlockModel.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "BlockModel.h"

@implementation BlockModel

+ (float) minWidth {
    static float minWidth = 6.0;
    return minWidth;
}
+ (float) maxWidth {
    static float maxWidth = 50.0;
    return maxWidth;
}


// ensure width and height are within bounds
- (void)setWidth:(NSNumber *)aWidth {
    
    float value = [aWidth floatValue];
    
    if (value < [[self class] minWidth]) {
        aWidth = [NSNumber numberWithFloat:[[self class] minWidth]];
    }
    else if (value > [[self class] maxWidth]) {
        aWidth = [NSNumber numberWithFloat:[[self class] maxWidth]];
    }
    
    [super setWidth:aWidth];
}

- (void)setHeight:(NSNumber *)aHeight {
    
    float value = [aHeight floatValue];
    
    if (value < [[self class] minWidth]/2.0) {
        aHeight = [NSNumber numberWithFloat:[[self class] minWidth]/2.0];
    }
    else if (value > [[self class] maxWidth]/2.0) {
        aHeight = [NSNumber numberWithFloat:[[self class] maxWidth]/2.0];
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
