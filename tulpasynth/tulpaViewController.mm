//
//  tulpaViewController.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "tulpaViewController.h"

//#include "TouchEntity.h"
#include "PinchEntity.h"
#include "RotateEntity.h"
#include "TapEntity.h"
#include "PanEntity.h"

#import "FallingBall.h"
#import "Square.h"


TouchEntity * _touchEntities[MAX_TOUCHES];
UInt32 g_numActiveTouches = 0;

PinchEntity * _pinchEntity;

RotateEntity * _rotateEntity;

PanEntity * _panEntity;

TapEntity * _tapEntity;


@implementation tulpaViewController

@synthesize fallingBalls, obstacles;

@synthesize context = _context;
@synthesize effect = _effect;

@synthesize pinchRecognizer;
@synthesize rotateRecognizer;
@synthesize panRecognizer;
@synthesize tapRecognizer;

@synthesize world;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (GLuint)setupTexture:(NSString *)fileName {
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }

    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(
                                                       spriteData,
                                                       width,
                                                       height,
                                                       8,
                                                       width*4,
                                                       CGImageGetColorSpace(spriteImage),
                                                       kCGImageAlphaPremultipliedLast
                                                       );
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST); 
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);        
    return texName;    
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (b2World*)world {
    return self->_world;
}

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
    
    // Load shaders
//    _texCoordSlot = glGetAttribLocation(programHandle, "TexCoordIn");

    // Instantiate touch objects
//    for(int i = 0; i < MAX_TOUCHES; i++) {
//        _touchEntities[i] = new TouchEntity();
//    }
    
    _pinchEntity = new PinchEntity(self.pinchRecognizer);
    
    _rotateEntity = new RotateEntity(self.rotateRecognizer);
    _panEntity = new PanEntity(self.panRecognizer);
    _tapEntity = new TapEntity(self.tapRecognizer);
    
    // Initialize game object lists

    self.fallingBalls = [[NSMutableArray alloc] init];
    self.obstacles = [[NSMutableArray alloc] init];

    
    // Initialize b2 graphics
    b2Vec2 gravity(0.0f, -50.0f);
    self->_world = new b2World(gravity);
    
//    b2BodyDef groundBodyDef;
//    groundBodyDef.position.Set(0.0f, -10.0f);
//    
//    b2Body* groundBody = self.world->CreateBody(&groundBodyDef);
//    
//    b2PolygonShape groundBox;
//    // groundBox is 100m wide and 20m tall
//    groundBox.SetAsBox(50.0f, 10.0f);
//    
//    // Create shape fixture with default fixture definition.  groundBody
//    // is 0.0 kg/m^2
//    groundBody->CreateFixture(&groundBox, 0.0f);
    
    
//    b2BodyDef fallingBodyDef;
//    // this body should move in response to forces
//    fallingBodyDef.type = b2_dynamicBody;
//    fallingBodyDef.position.Set(0.0f, 4.0f);
//    b2Body* fallingBody = self.world->CreateBody(&fallingBodyDef);
    
    // Create a box shape
//    b2PolygonShape dynamicBox;
//    dynamicBox.SetAsBox(1.0f, 1.0f);
    
    // Create fixture definition for box
//    b2FixtureDef fixtureDef;
//    fixtureDef.shape = &dynamicBox;
//    fixtureDef.density = 1.0f;
//    fixtureDef.friction = 0.3f;
//    
//    body->CreateFixture(&fixtureDef);
        
    

//    MoTouch::addCallback(touch_callback, NULL);
    
    // Create two starting squares for now
    Square * s;
    b2Vec2 pos(25.0, 50.0);
    s = [[Square alloc] initWithController:self withPosition:pos];
    [self.obstacles addObject:s];

    pos.Set(90.0, 40.0);
    s = [[Square alloc] initWithController:self withPosition:pos];
    [self.obstacles addObject:s];
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
//    for(int i = 0; i < MAX_TOUCHES; i++) {
//        delete _touchEntities[i];
//    }
    
    delete _pinchEntity;
    delete _rotateEntity;
    delete _panEntity;
    delete _tapEntity;
    
    delete self->_world;
    

    // TODO: Delete all physical entities
//    for (PhysicsEntity * e in PhysicsEntity.Instances) {
//        
//    }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)glkView:(GLKView*)view drawInRect:(CGRect)rect {
    glClearColor(1.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);

    
    // Draw all physics entities
    for (PhysicsEntity * e in PhysicsEntity.Instances) {
        [e draw];
    }    
}

- (IBAction)pinchGestureHandler:(id)sender {
    _pinchEntity->update();

    // All obstacles get the chance to handle pinch
    for (Obstacle * o in self.obstacles) {
        [o handlePinch:_pinchEntity];
    }
}

- (IBAction)rotateGestureHandler:(id)sender {
    _rotateEntity->update();

    // All obstacles have chance to handle rotate
    for (Obstacle * o in self.obstacles) {
        [o handleRotate:_rotateEntity];
    }
}

- (IBAction)panGestureHandler:(id)sender {
    _panEntity->update();

    // All obstacles can handle pan
    for (Obstacle * o in self.obstacles) {
        [o handlePan:_panEntity];
    }
}

- (IBAction)tapGestureHandler:(id)sender {
    _tapEntity->update();
    
    bool handled = false;

    // All obstacles can handle tap
    for (Obstacle * o in self.obstacles) {
        handled = [o handleTap:_tapEntity];
        
        if (handled) {
            break;
        }
    }
    
    if (!handled) {
        // Handle tap in empty space
        FallingBall* b = [[FallingBall alloc] initWithController:self withPosition:(*_tapEntity->touches[0]->position)];
        [fallingBalls addObject:b];

//        NSLog(@"empty!");
    }    
}

- (void)update {

    // Handle rendering due to touches
//    if (g_numActiveTouches == 1) {
//        if (![squares[0] handleTouch:_touchEntities[0]] && ![squares[1] handleTouch:_touchEntities[0]]) {
//            NSLog(@"drop ball");
//        }
//    }
    
    float32 timeStep = 1.0f / 60.0f;
    
    // Turn these bitches down to increase performance
    int32 velocityIterations = 8;
    int32 positionIterations = 2;

    self.world->Step(self.timeSinceLastUpdate, velocityIterations, positionIterations);
    
    // Update all physics entities
    for (PhysicsEntity * e in PhysicsEntity.Instances) {
        [e update];
    }
    
    
    // Update all obstacles
//    for (Obstacle * o in self.obstacles) {
//        [o update];
//    }
//    
//    // Update all falling balls
//    for (FallingBall * b in self.fallingBalls) {
//        [b update];
//    }
//    
//    // If there is a collision between a falling ball and an obstacle
//    for (Obstacle * o in self.obstacles) {
//        for (FallingBall * b in self.fallingBalls) {
//            
//        }
//    }

    
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


//void touch_callback( NSSet * touches, UIView * view, const std::vector<MoTouchTrack> & tracks, void * data)
//{
//    // iterate over touch points
//    CGPoint location;
//    for( UITouch * touch in touches )
//    {
//        // get the location
//        location = [touch locationInView:nil];
//        
//        // transform: to make landscape
//        double temp = location.x;
//        location.x = location.y;
//        location.y = temp;
//        
//        // NSLog( @"touch: %f, %f,", location.x, location.y );
//        
//        if( touch.phase == UITouchPhaseBegan )
//        {
//            // find idle touch entity
//            TouchEntity * entity = NULL;
//            for( int i = 0; i < MAX_TOUCHES; i++ )
//            {
//                // in case touch already active
//                if( _touchEntities[i]->touch_ref == touch )
//                    break;
//                
//                // find the next non-active touch
//                if( !_touchEntities[i]->active )
//                {
//                    entity = _touchEntities[i];
//                    break;
//                }
//            }
//            
//            // sanity check
//            if( entity != NULL )
//            {
//                // set
//                entity->active = true;
//                entity->touch_ref = touch;
//                entity->position->set(location.x, location.y, 0);
//                // count
//                g_numActiveTouches++;
//                // log it
//                NSLog( @"active touches: %d", g_numActiveTouches );
//            }
//        }
//        else if( touch.phase == UITouchPhaseMoved )
//        {
//            for( int i = 0; i < MAX_TOUCHES; i++ )
//            {
//                if( _touchEntities[i]->touch_ref == touch )
//                {
//                    _touchEntities[i]->position->set(location.x, location.y, 0);
//                    break;
//                }
//            }
//        }
//        else if( (touch.phase == UITouchPhaseEnded) || (touch.phase == UITouchPhaseCancelled) )
//        {
//            for( int i = 0; i < MAX_TOUCHES; i++ )
//            {
//                if( _touchEntities[i]->touch_ref == touch )
//                {
//                    // set
//                    _touchEntities[i]->active = false;
//                    _touchEntities[i]->touch_ref = NULL;
//                    
//                    // pack active touches
//                    for( int j = i+1; j < MAX_TOUCHES; j++ )
//                    {
//                        if( _touchEntities[j]->active )
//                        {
//                            // swap
//                            TouchEntity * swap = _touchEntities[i];
//                            _touchEntities[i] = _touchEntities[j];
//                            _touchEntities[j] = swap;
//                            // dangerous: advance i
//                            i = j;
//                        }
//                    }
//                    
//                    // count
//                    g_numActiveTouches--;
//                    // log
//                    NSLog( @"active touches: %d", g_numActiveTouches );
//                    
//                    break;
//                }
//            }
//        }
//    }
//}


@end
