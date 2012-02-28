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
    
    if (!self.height) {
        self.height = [NSNumber numberWithFloat:2.0];
    }
    
    if (!self.width) {
        self.width = [NSNumber numberWithFloat:6.0];
    }
}

@end
