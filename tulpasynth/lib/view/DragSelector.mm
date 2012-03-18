//
//  DragSelector.m
//  tulpasynth
//
//  Created by Colin Sullivan on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DragSelector.h"

@implementation DragSelector

- (void) initialize {
    [super initialize];
    
    self.effect.texture2d0.enabled = GL_FALSE;
    self.effect.useConstantColor = YES;
    static float opacity = 0.25;
    self.effect.constantColor = GLKVector4Make(
                                               opacity,
                                               opacity,
                                               opacity,
                                               opacity
                                               );
    self.position->Set(20, 20);
    self.width = 30;
    self.height = 15;
}

@end
