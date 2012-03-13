/**
 *  @file       tulpaViewController.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "tulpaViewController.h"

#include "mo_audio.h"

#import "Instrument.hpp"

#import "FallingBallModel.h"
#import "BlockModel.h"

#include "TouchEntity.h"
#include "PinchEntity.h"
#include "RotateEntity.h"
#include "TapEntity.h"
#include "PanEntity.h"
#include "LongPressEntity.h"

#import "b2EdgeShape.h"

#import "FallingBall.h"
#import "BlockObstacle.h"


//#include "FMPercussion.hpp"

TouchEntity * _touchEntities[MAX_TOUCHES];
UInt32 g_numActiveTouches = 0;

PinchEntity * _pinchEntity;

RotateEntity * _rotateEntity;

PanEntity * _panEntity;

TapEntity * _tapEntity;
LongPressEntity * _longPressEntity;


@implementation tulpaViewController

@synthesize startTime, safeUpdateTime, lastUpdateTime, waiting;

@synthesize glowingCircleTexture, glowingBoxTexture, shooterTexture, toolboxTexture, shooterGlowingTexture, shooterRadialMenuPointer, shooterRadialMenuBackground;

@synthesize fallingBalls, obstacles, wildBalls;

@synthesize context = _context;
@synthesize effect = _effect;

@synthesize pinchRecognizer, rotateRecognizer, panRecognizer, tapRecognizer, longPressRecognizer;

@synthesize world, collisionDetector, walls, toolbox, collisionFilter;

@synthesize socketHandler, waitingForIds;

@synthesize greenColor;

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
    
//    tulpaViewController* self = (tulpaViewController*)userData;
    
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
        
    // Render all instruments into output
    for (unsigned int i = 0; i < instruments::Instrument::Instances->size(); i++) {

        // Clear temporary output buffer
        tempFrames->resize(numFrames, NUM_CHANNELS, 0.0);

        (*instruments::Instrument::Instances)[i]->next_buf((*tempFrames));

        for(int j = 0; j < NUM_CHANNELS; j++) {
            // Add samples to master output for each channel
            for(unsigned int k = 0; k < numFrames; k++) {
                outputSamples[k*NUM_CHANNELS+j] += 0.4*(Float32)(*tempFrames)[k*NUM_CHANNELS+j];
            }
        }

    }
}

- (GLKTextureInfo*)loadTexture:(NSString*)imageFileName {
    NSError *error = nil;
    GLKTextureInfo* tex = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:imageFileName ofType:@"png"];
    tex = [GLKTextureLoader textureWithContentsOfFile:path options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:GLKTextureLoaderOriginBottomLeft] error:&error];
    if (error != nil) {
        NSLog(@"Error loading texture from image: %@", [error localizedDescription]);
        
        return nil;
    }
    else {
        return tex;
    }

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.socketHandler = [[SocketHandler alloc] initWithController:self];
    self.waitingForIds = [[NSMutableArray alloc] init];

    self.startTime = [NSDate dateWithTimeIntervalSinceNow:0.0f];

    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView * view = (GLKView *)self.view;
    view.context = self.context;
    
    [EAGLContext setCurrentContext:self.context];
        
    // load textures
    self.glowingCircleTexture = [self loadTexture:@"GlowingRing"];
    self.glowingBoxTexture = [self loadTexture:@"GlowingBox"];
    self.shooterTexture = [self loadTexture:@"Shooter"];
    self.shooterGlowingTexture = [self loadTexture:@"ShooterGlowing"];
    self.toolboxTexture = [self loadTexture:@"Radial-Menu"];
    self.shooterRadialMenuBackground = [self loadTexture:@"Shooter-Radial-Menu-Background"];
    self.shooterRadialMenuPointer = [self loadTexture:@"Shooter-Radial-Menu-Pointer"];
    
    self.greenColor = GLKVector4Make(43.0/255.0, 208.0/255.0, 5.0/255.0, 1.0);
    
    
    _pinchEntity = new PinchEntity(self.pinchRecognizer);
    _rotateEntity = new RotateEntity(self.rotateRecognizer);
    _panEntity = new PanEntity(self.panRecognizer);
    _tapEntity = new TapEntity(self.tapRecognizer);
    _longPressEntity = new LongPressEntity(self.longPressRecognizer);
    
    // Initialize game object lists
    self.fallingBalls = [[NSMutableArray alloc] init];
    self.obstacles = [[NSMutableArray alloc] init];
    self.wildBalls = [[NSMutableArray alloc] init];
    
    // Initialize b2 graphics
//    b2Vec2 gravity(0.0f, -50.0f);
    b2Vec2 gravity(0.0f, 0.0f);
    self->_world = new b2World(gravity);
    collisionDetector = new CollisionDetector(self);
    self->_world->SetContactListener(collisionDetector);
    collisionFilter = new CollisionFilter();
    self->_world->SetContactFilter(collisionFilter);
    
    // Create two starting squares for now
//    BlockObstacle * s;
//    b2Vec2 pos(25.0, 50.0);
//    s = [[BlockObstacle alloc] initWithController:self withPosition:pos];
//    [self.obstacles addObject:s];
//    
//    pos.Set(90.0, 40.0);
//    s = [[BlockObstacle alloc] initWithController:self withPosition:pos];
//    [self.obstacles addObject:s];
    
    // Left and right screen edges
    b2BodyDef wallsDef;
//    wallsDef.position = b2Vec2(PX_TO_M(self.view.frame.size.height/2), PX_TO_M(self.view.frame.size.width/2));
    walls = self.world->CreateBody(&wallsDef);
    
//    b2EdgeShape wallShape;
//
//    b2Vec2 topLeft(0.0, PX_TO_M(self.view.frame.size.width));
//    b2Vec2 topRight(PX_TO_M(self.view.frame.size.height), PX_TO_M(self.view.frame.size.width));
//    b2Vec2 bottomLeft(0.0, 0.0);
//    b2Vec2 bottomRight(PX_TO_M(self.view.frame.size.height), 0.0);
//
//    b2FixtureDef wallFixtureDef;
//    wallFixtureDef.friction = 0.1f;
//    wallFixtureDef.restitution = 0.75f;
//    wallFixtureDef.shape = &wallShape;
//
//    // Create left wall
//    wallShape.Set(bottomLeft, topLeft);
//    walls->CreateFixture(&wallFixtureDef);
//    
//    // Create right wall
//    wallShape.Set(bottomRight, topRight);
////    wallFixtureDef.shape = &wallShape;
//    walls->CreateFixture(&wallFixtureDef);
    
    self.toolbox = [[RadialToolbox alloc] initWithController:self withModel:NULL];
    
    // Register for model creation and deletion updates
    [[Model Instances] addObserver:self forKeyPath:@"objects" options:NSKeyValueObservingOptionNew context:NULL];
    
    // Audio setup
    NSLog(@"starting real-time audio...");    
    bool result = MoAudio::init(stk::SRATE, FRAMESIZE, NUM_CHANNELS);
    if (!result) {
        NSLog(@"cannot initialize real-time audio!");
        return;
    }
    result = MoAudio::start(audioCallback, (__bridge void*)self);
    if (!result) {
        // something went wrong
        NSLog(@"cannot start real-time audio!");
        return;
    }
    
    self.startTime = [NSDate dateWithTimeIntervalSinceNow:0.0];
    self.safeUpdateTime = [NSDate dateWithTimeInterval:0.0 sinceDate:self.startTime];
    self.lastUpdateTime = [NSDate dateWithTimeInterval:0.0 sinceDate:self.startTime];
    self.waiting = false;
    
    glEnable(GL_BLEND);
    glBlendFunc( GL_ONE, GL_ONE_MINUS_SRC_ALPHA );

}

- (void)beginCollision:(b2Contact*) contact {
    static float32 collisionStrength;
    
    static b2Body* body;
    
    static float32 widthOfSquare;
    widthOfSquare = nil;
    
    static id entityOne, entityTwo;
    
    body = contact->GetFixtureA()->GetBody();
    collisionStrength = body->GetLinearVelocity().LengthSquared()*body->GetMass();

    // Given a body, get its PhysicsEntity instance
    entityOne = ((__bridge id)body->GetUserData());
    
    body = contact->GetFixtureB()->GetBody();
    collisionStrength += body->GetLinearVelocity().LengthSquared()*body->GetMass();
    
    
    // Given a body, get its PhysicsEntity instance
    entityTwo = ((__bridge id)body->GetUserData());

    collisionStrength /= 2000;

    if ([entityOne isKindOfClass:[BlockObstacle class]] || [entityTwo isKindOfClass:[BlockObstacle class]]) {
        BlockObstacle* collidedSquare;
        if([entityOne isKindOfClass:[BlockObstacle class]]) {
            collidedSquare = entityOne;
        }
        else if([entityTwo isKindOfClass:[BlockObstacle class]]) {
            collidedSquare = entityTwo;
        }
        [collidedSquare handleCollision:collisionStrength];
    }
        
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
    
    delete _pinchEntity;
    delete _rotateEntity;
    delete _panEntity;
    delete _tapEntity;
    
    delete self->_world;
    delete collisionDetector;
    
    self.fallingBalls = nil;
    self.obstacles = nil;
    
//    [self.toolbox dealloc];
//    self.bodyToEntityMap = nil;

    

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

    
    // Draw toolbox
    [self.toolbox prepareToDraw];
    [self.toolbox draw];
    [self.toolbox postDraw];
    
    for (Obstacle* o in self.obstacles) {
        [o prepareToDraw];
        [o draw];
        [o postDraw];
    }
    
    for (WildBall* b in self.wildBalls) {
        [b prepareToDraw];
        [b draw];
        [b postDraw];
    }

    
//    // Draw all GLViews
//    for (GLView* e in [GLView Instances]) {
//        [e prepareToDraw];
//        [e draw];
//        [e postDraw];
//    }    
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
    
    // Allow toolbox to handle pan
//    [self.toolbox handlePan:_panEntity];

    // All obstacles can handle pan
    for (Obstacle * o in self.obstacles) {
        [o handlePan:_panEntity];
    }
}

- (IBAction)tapGestureHandler:(id)sender {
    _tapEntity->update();
    
    
    if (self.toolbox.active) {
        if ([self.toolbox handleTap:_tapEntity]) {
            return;
        }
        else {
            self.toolbox.active = false;
            return;        
        }
    }

    // All obstacles can handle tap
    for (Obstacle * o in self.obstacles) {
        if ([o handleTap:_tapEntity]) {
            return;
        }
    }
    
    // Handle tap in empty space

    // Move toolbox to that point and display
    self.toolbox.position = _tapEntity->touches[0]->position;
    self.toolbox.active = true;
    

//    if (!handled) {
//        
//        // Create falling ball model
//        FallingBallModel* bm = [[FallingBallModel alloc] initWithController:self withAttributes:
//                                [NSDictionary dictionaryWithObjectsAndKeys:
//                                 [NSDictionary dictionaryWithObjectsAndKeys:
//                                  [NSNumber numberWithFloat:touchPosition->x], @"x",
//                                  [NSNumber numberWithFloat:touchPosition->y], @"y", nil], @"initialPosition",
//                                nil]];
//
//        // create corresponding view
//        FallingBall* b = [[FallingBall alloc] initWithController:self withModel:bm];
//        [fallingBalls addObject:b];
//
////        NSLog(@"empty!");
//    }    
}

- (IBAction)longPressHandler:(id)sender {
    _longPressEntity->update();

    
    for (Obstacle* ob in self.obstacles) {
        if ([ob handleLongPress:_longPressEntity]) {
            return;
        }
    }
    
//    if (_longPressEntity->state == GestureEntityStateStart) {      
//    }
    
}

- (void)update {
    
//    float32 timeStep = 1.0f / 40.0f;
    
    // Turn these bitches down to increase performance
    int32 velocityIterations = 7;
    int32 positionIterations = 3;
    
    // Update toolbox no matter what
    [self.toolbox update];
    
    if (self.waiting) {
        return;
    }

    // if it is safe to update
//    static NSTimeInterval safeUpdateInterval;
//    safeUpdateInterval = [self.safeUpdateTime timeIntervalSinceDate:self.lastUpdateTime];
    self.world->Step(self.timeSinceLastUpdate, velocityIterations, positionIterations);

    // update all obstacles
    for (Obstacle* o in self.obstacles) {
        [o update];
    }
    
    NSMutableArray* ballsToDelete = [[NSMutableArray alloc] init];
    
    // update all wild balls
    for (WildBall* b in self.wildBalls) {
        [b update];
        
        // if ball is off screen
        if (
            b.position->x > PX_TO_M(self.view.frame.size.height)
            ||
            b.position->x < 0
            ||
            b.position->y > PX_TO_M(self.view.frame.size.width)
            ||
            b.position->y < 0
            ) {
            
            [ballsToDelete addObject:b];
        }
        
    }
    
    // delete all balls that moved offscreen
    for (WildBall* b in ballsToDelete) {
        [self.wildBalls removeObject:b];
    }
    
    // Update all GLView instances
    //    for (GLView* e in [GLView Instances]) {
    //        [e update];
    //    }
    
    //    static BOOL done = false;
    //    if (!done && [self.startTime timeIntervalSinceNow] < -10.0) {
    //        NSLog(@"10 passed");
    //        
    //        self.toolbar.mouseJoint->SetTarget(b2Vec2(100, 0));
    //        
    //        done = true;
    //    }
    
    
    //    float aspect = fabsf(self.view.bounds.size.width/self.view.bounds.size.height);
    ////    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(60.0f), aspect, 1.0f, -1.0f);
    //    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(0.125 * 2 * M_PI, 2.0/3.0, 2, -1);
    //    self.effect.transform.projectionMatrix = projectionMatrix;
    
//        self.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0.0];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"timeSinceLastUpdate: %f", self.timeSinceLastUpdate);
//    NSLog(@"timeSinceLastDraw: %f", self.timeSinceLastDraw);
//    NSLog(@"timeSinceFirstResume: %f", self.timeSinceFirstResume);
//    NSLog(@"timeSinceLastResume: %f", self.timeSinceLastResume);
//    self.paused = !self.paused;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    NSLog(@"tulpaViewController.observeValueForKeyPath\nkeyPath:\t%@\nchange:\t%@", keyPath, change);
    
    // if the list of model instances has changed
    if (object == [Model Instances]) {
        
        // if a model was added
        if ([[change valueForKey:@"kind"] intValue] == NSKeyValueChangeInsertion) {
            
            Model* addedModel = [[[Model Instances] objects] objectAtIndex:[[change valueForKey:@"indexes"] firstIndex]];
            Class addedModelClass = [addedModel class];

            // if a BlockObstacle model was added
            if (addedModelClass == [BlockModel class]) {
                // create BlockObstacle view
                BlockObstacle* s = [[BlockObstacle alloc] 
                             initWithController:self
                             withModel:addedModel];
                [self.obstacles addObject:s];
            }
            // if a shooter model was added
            else if(addedModelClass == [ShooterModel class]) {
                Shooter* s = [[Shooter alloc] initWithController:self withModel:addedModel];
                [self.obstacles addObject:s];
                
            }
            else if(addedModelClass == [WildBallModel class]) {
                WildBall* b = [[WildBall alloc] initWithController:self withModel:addedModel];
                [self.wildBalls addObject:b];
            }
            
        }
        
    }

}


@end
