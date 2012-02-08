//
//  tulpaViewController.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "tulpaViewController.h"

#include "TouchEntity.h"
#include "PinchEntity.h"
#include "RotateEntity.h"


#import "Square.h"


TouchEntity * _touchEntities[MAX_TOUCHES];
UInt32 g_numActiveTouches = 0;

PinchEntity * _pinchEntity;

RotateEntity * _rotateEntity;


@implementation tulpaViewController

Square* squares[2];

@synthesize context = _context;
@synthesize effect = _effect;

@synthesize pinchRecognizer;
@synthesize rotateRecognizer;
//@synthesize touchEntities = _touchEntities;


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

    // Instantiate touch objects
    for(int i = 0; i < MAX_TOUCHES; i++) {
        _touchEntities[i] = new TouchEntity();
    }
    
    _pinchEntity = new PinchEntity(self.pinchRecognizer);
    
    _rotateEntity = new RotateEntity(self.rotateRecognizer);
    

    MoTouch::addCallback(touch_callback, NULL);

    
    squares[0] = [[Square alloc] init];
    squares[1] = [[Square alloc] init];

    squares[0].position->set(480/2, 320/2, 0);
    squares[1].position->set(100, 100, 0);
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
    
    // Delete touch objects
    for(int i = 0; i < MAX_TOUCHES; i++) {
        delete _touchEntities[i];
    }

    [squares[0] release];
    [squares[1] release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)glkView:(GLKView*)view drawInRect:(CGRect)rect {
    glClearColor(_curRed, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);

    [squares[0] draw];
    [squares[1] draw];

}

- (IBAction)pinchGestureHandler:(id)sender {
    if ([pinchRecognizer numberOfTouches] == 2) {
        _pinchEntity->update();
        
        [squares[0] handlePinch:_pinchEntity];
        [squares[1] handlePinch:_pinchEntity];
    }
}

- (IBAction)rotateGestureHandler:(id)sender {
    if ([rotateRecognizer numberOfTouches] == 2) {
        _rotateEntity->update();
        
        [squares[0] handleRotate:_rotateEntity];
        [squares[1] handleRotate:_rotateEntity];
    }
}

- (void)update {

    // Handle rendering due to touches
    if (g_numActiveTouches == 1) {
        [squares[0] handleTouch:_touchEntities[0]];
        [squares[1] handleTouch:_touchEntities[0]];
    }

    [squares[0] update];
    [squares[1] update];
    

    
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
    
    if (_curRed <= 0.25) {
        _curRed = 0.25;
        _increasing = YES;
    }
    
//    float aspect = fabsf(self.view.bounds.size.width/self.view.bounds.size.height);
////    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(60.0f), aspect, 1.0f, -1.0f);
//    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(0.125 * 2 * M_PI, 2.0/3.0, 2, -1);
//    self.effect.transform.projectionMatrix = projectionMatrix;

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"timeSinceLastUpdate: %f", self.timeSinceLastUpdate);
//    NSLog(@"timeSinceLastDraw: %f", self.timeSinceLastDraw);
//    NSLog(@"timeSinceFirstResume: %f", self.timeSinceFirstResume);
//    NSLog(@"timeSinceLastResume: %f", self.timeSinceLastResume);
//    self.paused = !self.paused;
}


void touch_callback( NSSet * touches, UIView * view, const std::vector<MoTouchTrack> & tracks, void * data)
{
    // iterate over touch points
    CGPoint location;
    for( UITouch * touch in touches )
    {
        // get the location
        location = [touch locationInView:nil];
        
        // transform: to make landscape
        double temp = location.x;
        location.x = location.y;
        location.y = temp;
        
        // NSLog( @"touch: %f, %f,", location.x, location.y );
        
        if( touch.phase == UITouchPhaseBegan )
        {
            // find idle touch entity
            TouchEntity * entity = NULL;
            for( int i = 0; i < MAX_TOUCHES; i++ )
            {
                // in case touch already active
                if( _touchEntities[i]->touch_ref == touch )
                    break;
                
                // find the next non-active touch
                if( !_touchEntities[i]->active )
                {
                    entity = _touchEntities[i];
                    break;
                }
            }
            
            // sanity check
            if( entity != NULL )
            {
                // set
                entity->active = true;
                entity->touch_ref = touch;
                entity->position->set(location.x, location.y, 0);
                // count
                g_numActiveTouches++;
                // log it
                NSLog( @"active touches: %d", g_numActiveTouches );
            }
        }
        else if( touch.phase == UITouchPhaseMoved )
        {
            for( int i = 0; i < MAX_TOUCHES; i++ )
            {
                if( _touchEntities[i]->touch_ref == touch )
                {
                    _touchEntities[i]->position->set(location.x, location.y, 0);
                    break;
                }
            }
        }
        else if( (touch.phase == UITouchPhaseEnded) || (touch.phase == UITouchPhaseCancelled) )
        {
            for( int i = 0; i < MAX_TOUCHES; i++ )
            {
                if( _touchEntities[i]->touch_ref == touch )
                {
                    // set
                    _touchEntities[i]->active = false;
                    _touchEntities[i]->touch_ref = NULL;
                    
                    // pack active touches
                    for( int j = i+1; j < MAX_TOUCHES; j++ )
                    {
                        if( _touchEntities[j]->active )
                        {
                            // swap
                            TouchEntity * swap = _touchEntities[i];
                            _touchEntities[i] = _touchEntities[j];
                            _touchEntities[j] = swap;
                            // dangerous: advance i
                            i = j;
                        }
                    }
                    
                    // count
                    g_numActiveTouches--;
                    // log
                    NSLog( @"active touches: %d", g_numActiveTouches );
                    
                    break;
                }
            }
        }
    }
}


@end
