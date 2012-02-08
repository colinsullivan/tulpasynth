//
//  tulpaViewController.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "tulpaViewController.h"

#import "Square.h"




@implementation tulpaViewController

Square* s;
@synthesize context = _context;
@synthesize effect = _effect;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _increasing = YES;
        _curRed = 0.0;        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView * view = (GLKView *)self.view;
    view.context = self.context;
    
    [EAGLContext setCurrentContext:self.context];

    s = [[Square alloc] init];

    s.position->set(0.9, 0.5, 0);
    s.width = 0.5;
    s.height = 0.5;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

    [EAGLContext setCurrentContext:self.context];
        
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;

    [s release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)glkView:(GLKView*)view drawInRect:(CGRect)rect {
    glClearColor(_curRed, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);

    [s draw];

}

- (void)update {
    
    if (_increasing) {
        _curRed += 0.5 * self.timeSinceLastUpdate;
    }
    else {
        _curRed -= 0.5 * self.timeSinceLastUpdate;
    }
    
    if (_curRed >= 1.0) {
        _curRed = 1.0;
        _increasing = NO;
    }
    
    if (_curRed <= 0.0) {
        _curRed = 0.0;
        _increasing = YES;
    }
    
//    float aspect = fabsf(self.view.bounds.size.width/self.view.bounds.size.height);
////    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(60.0f), aspect, 1.0f, -1.0f);
//    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(0.125 * 2 * M_PI, 2.0/3.0, 2, -1);
//    self.effect.transform.projectionMatrix = projectionMatrix;

    [s update];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"timeSinceLastUpdate: %f", self.timeSinceLastUpdate);
//    NSLog(@"timeSinceLastDraw: %f", self.timeSinceLastDraw);
//    NSLog(@"timeSinceFirstResume: %f", self.timeSinceFirstResume);
//    NSLog(@"timeSinceLastResume: %f", self.timeSinceLastResume);
//    self.paused = !self.paused;
}

@end
