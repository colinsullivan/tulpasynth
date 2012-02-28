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

- (void) initialize {
    [super initialize];
    
    if (!self.height || !self.width) {
        self.height = [NSNumber numberWithFloat:2.0];
        self.width = [NSNumber numberWithFloat:2.0];
    }
}


@end
