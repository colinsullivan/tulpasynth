//
//  tulpaViewController.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>

@interface tulpaViewController : GLKViewController {
    float _curRed;
    BOOL _increasing;
    
@private
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    float _rotation;
}

@property (strong, nonatomic) EAGLContext * context;
@property (strong, nonatomic) GLKBaseEffect * effect;


@end
