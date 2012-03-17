/**
 *  @file       Obstacle.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "Obstacle.h"

#import "tulpaViewController.h"

@implementation Obstacle

@synthesize color, selected;

- (void) setColor:(GLKVector4)aColor {
    self.effect.useConstantColor = YES;
    color = aColor;
    self.effect.constantColor = aColor;
}

- (void) setSelected:(BOOL)wasSelected {
    if (wasSelected) {
        self.color = self.controller.orangeColor;
        [self.controller.selectedObstacles addObject:self];
    }
    else {
        self.color = self.controller.greenColor;
    }
    selected = wasSelected;
}

- (void) initialize {
    [super initialize];
    
    self.color = self.controller.greenColor;
}

- (void) handleTapOccurred:(TapEntity *)aTap {
    [super handleTapOccurred:aTap];
    self.selected = !self.selected;
}

@end
