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

#include "FMPercussion.hpp"


TouchEntity * _touchEntities[MAX_TOUCHES];
UInt32 g_numActiveTouches = 0;

PinchEntity * _pinchEntity;

RotateEntity * _rotateEntity;

PanEntity * _panEntity;

TapEntity * _tapEntity;


@implementation tulpaViewController

@synthesize glowingCircleTexture;

@synthesize fallingBalls, obstacles;

@synthesize context = _context;
@synthesize effect = _effect;

@synthesize pinchRecognizer, rotateRecognizer, panRecognizer, tapRecognizer;

@synthesize world, collisionDetector;

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


void audioCallback(Float32 * buffer, UInt32 numFrames, void * userData) {
    
    tulpaViewController* self = (tulpaViewController*)userData;
    
    static stk::StkFrames* tempFrames = new stk::StkFrames(0.0, FRAMESIZE, NUM_CHANNELS);
    
    /* Zero output buffer */
    Float32* outputSamples = buffer;
    for(unsigned int i = 0; i < numFrames; i++) {
        for(int c = 0; c < NUM_CHANNELS; c++) {
            outputSamples[i*NUM_CHANNELS+c] = 0.0;
        }
    }

    /**
     *  Instrument test.
     **/
//    static int i = 0;
//    static bool played = false;
//
//    i += numFrames;
//    if (!played && i > stk::SRATE*2) {
//        NSLog(@"playing");
//        self->instrs[0]->play();
//        played = true;
//    }
    /**
     *  End instrument test.
     **/
    
    // Clear temporary output buffer
    tempFrames->resize(numFrames, NUM_CHANNELS, 0.0);
    
    // Render all instruments into output
    for (unsigned int i = 0; i < self->instrs.size(); i++) {
        self->instrs[i]->next_buf((*tempFrames));

        for(int i = 0; i < NUM_CHANNELS; i++) {
            // Add samples to master output for each channel
            for(unsigned int k = 0; k < numFrames; k++) {
                outputSamples[k*NUM_CHANNELS+i] += (Float32)(*tempFrames)[k*NUM_CHANNELS+i];
            }
        }
    }
    
    
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
        
    // load textures
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GlowingRing" ofType:@"png"];
    self.glowingCircleTexture = [GLKTextureLoader textureWithContentsOfFile:path options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:GLKTextureLoaderOriginBottomLeft] error:&error];
    if (error != nil) {
        NSLog(@"Error loading texture from image: %@", [error localizedDescription]);
    }

    
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
    collisionDetector = new CollisionDetector((id*)self);
    self->_world->SetContactListener(collisionDetector);
    
    //    MoTouch::addCallback(touch_callback, NULL);
    
    // Create two starting squares for now
    Square * s;
    b2Vec2 pos(25.0, 50.0);
    s = [[Square alloc] initWithController:self withPosition:pos];
    [self.obstacles addObject:s];
    [[PhysicsEntity Instances] addObject:s];
    
    pos.Set(90.0, 40.0);
    s = [[Square alloc] initWithController:self withPosition:pos];
    [self.obstacles addObject:s];
    [[PhysicsEntity Instances] addObject:s];
    
    // Create a single FM percussion instrument for now
    instruments::FMPercussion* fmPerc = new instruments::FMPercussion();
    self->instrs.push_back(fmPerc);
    
    // Audio setup
    NSLog(@"starting real-time audio...");    
    bool result = MoAudio::init(stk::SRATE, FRAMESIZE, NUM_CHANNELS);
    if (!result) {
        NSLog(@"cannot initialize real-time audio!");
        return;
    }
    result = MoAudio::start(audioCallback, (void*)self);
    if (!result) {
        // something went wrong
        NSLog(@"cannot start real-time audio!");
        return;
    }
    

}

- (void)beginCollision:(b2Contact*) contact {
    static float32 collisionStrength;
    
    static b2Body* body;
    
    body = contact->GetFixtureA()->GetBody();
    collisionStrength = body->GetLinearVelocity().LengthSquared()*body->GetMass();
    body = contact->GetFixtureB()->GetBody();
    collisionStrength += body->GetLinearVelocity().LengthSquared()*body->GetMass();
    
    collisionStrength /= 2000;
//    NSLog(@"collisionStrength: %f", collisionStrength);
    self->instrs[0]->velocity(collisionStrength);
    self->instrs[0]->play();
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
    delete collisionDetector;
    

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
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    

    
    // Draw all physics entities
    for (PhysicsEntity * e in PhysicsEntity.Instances) {
        [e prepareToDraw];
        [e draw];
        [e postDraw];
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
        [[PhysicsEntity Instances] addObject:b];

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
