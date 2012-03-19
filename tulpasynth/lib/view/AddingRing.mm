//
//  AddingRing.m
//  tulpasynth
//
//  Created by Colin Sullivan on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddingRing.h"

#import "tulpaViewController.h"

@implementation AddingRing

- (void) initialize {
    [super initialize];
    
    self.width = 12;
    self.height = 12;
    
    self.angle = 0.0;
    
    self.effect.texture2d0.name = self.controller.addingRingTexture.name;
}

@end
