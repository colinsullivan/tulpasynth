/**
 *  @file       AddingRing.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

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
