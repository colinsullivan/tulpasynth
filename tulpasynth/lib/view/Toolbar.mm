//
//  Toolbar.mm
//  tulpasynth
//
//  Created by Colin Sullivan on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Toolbar.h"

#import "tulpaViewController.h"

@implementation Toolbar

- (void) initialize {
    [super initialize];
    
    
    
}

-(void)prepareToDraw {
    self.effect.texture2d0.name = self.controller.toolbarTexture.name;
    
    [super prepareToDraw];
}


- (GLKMatrix4)currentModelViewTransform {
    GLKMatrix4 modelViewMatrix = [super currentModelViewTransform];
    
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 400, 400, 0.0);
    
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, self.controller.view.frame.size.width, 200, 1.0f);
    
    return modelViewMatrix;
}



@end
