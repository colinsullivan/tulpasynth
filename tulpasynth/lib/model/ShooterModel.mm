//
//  ShooterModel.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShooterModel.h"

@implementation ShooterModel

@synthesize rate;

- (void) initialize {
    [super initialize];
    
    if (!self.width && !self.height) {
        self.width = [NSNumber numberWithFloat:5.0];
        self.height = [NSNumber numberWithFloat:5.0];
    }
    
    if (!self.rate) {
        self.rate = [NSNumber numberWithFloat:1.0];
    }
}

@end
