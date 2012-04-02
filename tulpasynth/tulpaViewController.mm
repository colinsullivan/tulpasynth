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

#include "TrigLookupTables.h"

#import "b2EdgeShape.h"

#import "FallingBall.h"
#import "BlockObstacle.h"

#import "ReceivingShooterModel.h"
#import "ReceivingShooter.h"

#include "Ambience.hpp"

instruments::Ambience* ambienceInstr;



//#include "FMPercussion.hpp"

TouchEntity * _touchEntities[MAX_TOUCHES];
UInt32 g_numActiveTouches = 0;

PinchEntity * _pinchEntity;

RotateEntity * _rotateEntity;

PanEntity * _panEntity;

TapEntity * _tapEntity;
LongPressEntity * _longPressEntity;


@implementation tulpaViewController

@synthesize startTime, safeUpdateTime, lastUpdateTime;

@synthesize glowingCircleTexture, glowingBoxTexture, shooterTexture,
    toolboxTexture, shooterGlowingTexture, shooterRadialMenuPointer,
    shooterRadialMenuBackground, triObstacleTexture, blackholeTexture,
    deleteButtonTexture, toolbarTexture, addingRingTexture, wildBallTexture,
    wildBallGlowTexture, receivingShooterTexture, receivingShooterGlowingTexture;

@synthesize fallingBalls, obstacles, wildBalls, selectedObstacles;

@synthesize context = _context;
@synthesize effect = _effect;

@synthesize pinchRecognizer, rotateRecognizer, panRecognizer, tapRecognizer, longPressRecognizer;

@synthesize world, collisionDetector, walls, toolbox, toolbar, collisionFilter;

@synthesize socketHandler, waitingForIds, physicsEntitiesToDestroy;

@synthesize greenColor, orangeColor, redColor;

@synthesize dragSelector;

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
        stk::StkFloat gain = (*instruments::Instrument::Instances)[i]->gain();

        for(int j = 0; j < NUM_CHANNELS; j++) {
            // Add samples to master output for each channel
            for(unsigned int k = 0; k < numFrames; k++) {
                outputSamples[k*NUM_CHANNELS+j] += gain*(Float32)(*tempFrames)[k*NUM_CHANNELS+j];
//                if (outputSamples[k*NUM_CHANNELS+j] > 1.0) {
//                    NSLog(@"Clipping!");
//                }
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
    
    TrigLookupTables::generate();
    
    self.physicsEntitiesToDestroy = [[NSMutableArray alloc] init];
    self.selectedObstacles = [[NSMutableArray alloc] init];
    
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
    self.triObstacleTexture = [self loadTexture:@"triobstacle"];
    self.blackholeTexture = [self loadTexture:@"blackhole"];
    self.deleteButtonTexture = [self loadTexture:@"delete-button"];
    self.toolbarTexture = [self loadTexture:@"Toolbar"];
    self.addingRingTexture = [self loadTexture:@"AddCircle"];
    self.wildBallTexture = [self loadTexture:@"WildBall"];
    self.wildBallGlowTexture = [self loadTexture:@"WildBallGlow"];
    self.receivingShooterTexture = [self loadTexture:@"ReceivingShooter"];
    self.receivingShooterGlowingTexture = [self loadTexture:@"ReceivingShooterGlowing"];
    
    
    self.greenColor = GLKVector4Make(43.0/255.0, 208.0/255.0, 5.0/255.0, 1.0);
    self.orangeColor = GLKVector4Make(227.0/255.0, 151.0/255.0, 19.0/255.0, 1.0);
    self.redColor = GLKVector4Make(249.0/255.0, 28.0/255.0, 28.0/255.0, 1.0);
    
    
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
    
    b2EdgeShape wallShape;

    b2Vec2 topLeft(0.0, PX_TO_M(self.view.frame.size.width));
    b2Vec2 topRight(PX_TO_M(self.view.frame.size.height), PX_TO_M(self.view.frame.size.width));
    b2Vec2 bottomLeft(0.0, 0.0);
    b2Vec2 bottomRight(PX_TO_M(self.view.frame.size.height), 0.0);

    b2FixtureDef wallFixtureDef;
    wallFixtureDef.friction = 0.1f;
    wallFixtureDef.restitution = 1.0f;
    wallFixtureDef.shape = &wallShape;

    // Create left wall
    wallShape.Set(bottomLeft, topLeft);
    walls->CreateFixture(&wallFixtureDef);
    
    // Create right wall
    wallShape.Set(bottomRight, topRight);
//    wallFixtureDef.shape = &wallShape;
    walls->CreateFixture(&wallFixtureDef);
    
    // create bottom wall
    wallShape.Set(bottomLeft, bottomRight);
    walls->CreateFixture(&wallFixtureDef);
    
    // create top wall
    wallShape.Set(topLeft, topRight);
    walls->CreateFixture(&wallFixtureDef);
        
    // Register for model creation and deletion updates
    [[Model Instances] addObserver:self forKeyPath:@"objects" options:NSKeyValueObservingOptionNew context:NULL];
    
    // Audio setup
    NSLog(@"starting real-time audio...");
    stk::Stk::setSampleRate(22050.0);
    bool result = MoAudio::init(stk::Stk::sampleRate(), FRAMESIZE, NUM_CHANNELS);
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
    
    self.toolbar = [[Toolbar alloc] initWithController:self withModel:NULL];
    self.toolbar.active = true;

    
    self.startTime = [NSDate dateWithTimeIntervalSinceNow:0.0];
    self.safeUpdateTime = [NSDate dateWithTimeInterval:0.0 sinceDate:self.startTime];
    self.lastUpdateTime = [NSDate dateWithTimeInterval:0.0 sinceDate:self.startTime];
    
    glEnable(GL_BLEND);
    glBlendFunc( GL_ONE, GL_ONE_MINUS_SRC_ALPHA );
    
    self.dragSelector = [[DragSelector alloc] initWithController:self withModel:NULL];
    self.dragSelector.active = false;
    
    [[GLView class] initializeBuffers];
    
    ambienceInstr = new instruments::Ambience();
    ((instruments::Instrument*)ambienceInstr)->finish_initializing();
    ((instruments::Instrument*)ambienceInstr)->play();
    ((instruments::Instrument*)ambienceInstr)->gain(0.15);
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
    
    [entityOne handleCollision:entityTwo withStrength:collisionStrength];
    [entityTwo handleCollision:entityOne withStrength:collisionStrength];

//    if ([entityOne isKindOfClass:[BlockObstacle class]] || [entityTwo isKindOfClass:[BlockObstacle class]]) {
//        BlockObstacle* collidedSquare;
//        if([entityOne isKindOfClass:[BlockObstacle class]]) {
//            collidedSquare = entityOne;
//        }
//        else if([entityTwo isKindOfClass:[BlockObstacle class]]) {
//            collidedSquare = entityTwo;
//        }
//        [collidedSquare handleCollision:collisionStrength];
//    }
//    else if ([entityOne isKindOfClass:[TriObstacle class]] || [entityTwo isKindOfClass:[TriObstacle class]]) {
//        TriObstacle* collidedTri;
//        if ([entityOne isKindOfClass:[TriObstacle class]]) {
//            collidedTri = entityOne;
//        }
//        else if ([entityTwo isKindOfClass:[TriObstacle class]]) {
//            collidedTri = entityTwo;
//        }
//        [collidedTri handleCollision:collisionStrength];
//    }
        
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

    // draw drag selector
    [self.dragSelector prepareToDraw];
    [self.dragSelector draw];
    [self.dragSelector postDraw];
    
//    // Draw toolbox
//    [self.toolbox prepareToDraw];
//    [self.toolbox draw];
//    [self.toolbox postDraw];
    
    [self.toolbar prepareToDraw];
    [self.toolbar draw];
    [self.toolbar postDraw];        
    
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
    
    // if user is still dragging
    if ((_panEntity->state == GestureEntityStateUpdate || _panEntity->state == GestureEntityStateEnd) && self.dragSelector.panner == _panEntity) {
        [self.dragSelector handlePan:_panEntity];
        return;
    }
    
    // Allow toolbox to handle pan
//    [self.toolbox handlePan:_panEntity];

    // All obstacles can handle pan
    for (Obstacle * o in self.obstacles) {
        if([o handlePan:_panEntity]) {
            return;
        }
    }
    
    if ([self.toolbar handlePan:_panEntity]) {
        return;
    }
    
    // pan event was in empty space, user is dragging
    if (_panEntity->state == GestureEntityStateStart) {
//        NSLog(@"dragSelector handling pan in empty space");
//        [self.dragSelector handlePan:_panEntity];  
    }
}

- (IBAction)tapGestureHandler:(id)sender {
    _tapEntity->update();
    
    // if toolbar is open
    if (self.toolbar.open) {
        
        [self.toolbar handleTap:_tapEntity];
        
        [self.toolbar animateClosed];
        [self deselectAllObstacles];
        return;
    }
    
//    if (self.toolbox.active) {
//        if ([self.toolbox handleTap:_tapEntity]) {
//            return;
//        }
//        else {
//            self.toolbox.active = false;
//            return;        
//        }
//    }

    // All obstacles can handle tap
    for (Obstacle * o in self.obstacles) {
        if ([o handleTap:_tapEntity]) {
//            NSLog(@"obstacle handled tap");
            return;
        }
    }
    
    // Handle tap in empty space
    
    // if there are obstacles currently selected
    if ([self.selectedObstacles count]) {
        // deselect all selected
        [self deselectAllObstacles];
    }
    else {
//        // Move toolbox to that point and display
//        self.toolbox.position = _tapEntity->touches[0]->position;
//        self.toolbox.active = true;
        
        // open toolbar
//        NSLog(@"opening toolbar");
        [self.toolbar animateOpen:_tapEntity->touches[0]->position];
    }    

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
    
    // update drag selector no matter what
    [self.dragSelector update];
    
//    // Update toolbox no matter what
//    [self.toolbox update];
    
    [self.toolbar update];
    
    // if it is safe to update
//    static NSTimeInterval safeUpdateInterval;
//    safeUpdateInterval = [self.safeUpdateTime timeIntervalSinceDate:self.lastUpdateTime];
    self.world->Step(self.timeSinceLastUpdate, velocityIterations, positionIterations);

    // update all obstacles
    for (Obstacle* o in self.obstacles) {
        [o update];
    }
    
//    NSMutableArray* ballsToDelete = [[NSMutableArray alloc] init];
    
    // update all wild balls
    for (WildBall* b in self.wildBalls) {
        [b update];
//        // if ball is off screen
//        if (
//            b.position->x > PX_TO_M(self.view.frame.size.height)
//            ||
//            b.position->x < 0
//            ||
//            b.position->y > PX_TO_M(self.view.frame.size.width)
//            ||
//            b.position->y < 0
//            ) {
//            
//            [ballsToDelete addObject:b];
//        }
        
    }
    
    // delete all balls that moved offscreen
//    for (WildBall* b in ballsToDelete) {
//        [self.wildBalls removeObject:b];
//    }
    
    for (PhysicsEntity* e in self.physicsEntitiesToDestroy) {
        [e destroy];
    }
    self.physicsEntitiesToDestroy = [[NSMutableArray alloc] init];
    
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
            
            if (!addedModel) {
                NSLog(@"!addedModel");
                return;
            }
            else {
                PhysicsEntityModel* m = (PhysicsEntityModel*)addedModel;
                if(
                   !b2IsValid([[m.position valueForKey:@"x"] floatValue])
                   ||
                   !b2IsValid([[m.position valueForKey:@"y"] floatValue])
                   ) {
                    NSLog(@"addedModel position invalid!\n\tx:\t%f\n\ty:\t%f", [[m.position valueForKey:@"x"] floatValue], [[m.position valueForKey:@"y"] floatValue]);
                    m.destroyed = [NSNumber numberWithBool:true];
                    return;
                }
            }

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
            // a wild ball was created
            else if(addedModelClass == [WildBallModel class]) {
                WildBall* b = [[WildBall alloc] initWithController:self withModel:addedModel];
                [self.wildBalls addObject:b];
            }
            else if (addedModelClass == [TriObstacleModel class]) {
                TriObstacle* t = [[TriObstacle alloc] initWithController:self withModel:addedModel];
                [self.obstacles addObject:t];
            }
            else if (addedModelClass == [BlackholeModel class]) {
                // create blackhole obstacle
                Blackhole* b = [[Blackhole alloc] initWithController:self withModel:addedModel];
                [self.obstacles addObject:b];
            }
            else if (addedModelClass == [ReceivingShooterModel class]) {
                ReceivingShooter* s = [[ReceivingShooter alloc] initWithController:self withModel:addedModel];
                [self.obstacles addObject:s];
            }
            
        }
        // if a model was deleted
        else if ([[change valueForKey:@"kind"] intValue] == NSKeyValueChangeRemoval) {
//            NSLog(@"model was removed");

            // delete corresponding view
//            Model* removedModel = [[[Model Instances] objects] objectAtIndex:[[change valueForKey:@"indexes"] firstIndex]];
//            Class removedModelClass = [removedModel class];
//            NSLog(@"model that was removed: %@", removedModel);


//            if (removedModelClass == [WildBallModel class]) {
//                [removedModel destroy];
//            }
            
            
        }
        
    }

}

- (void) selectObstacles:(NSMutableArray*)obstaclesToSelect {
    
    // for each currently selected obstacle
    for (Obstacle* o in self.selectedObstacles) {
        // deselect
        o.selected = false;
    }
    
    // for each obstacle in our new list
    for (Obstacle* o in obstaclesToSelect) {
        o.selected = true;
    }
    
    // save new list
    self.selectedObstacles = obstaclesToSelect;
    
}
- (void) selectObstacle:(Obstacle*)obstacleToSelect {
    [self selectObstacles:[NSMutableArray arrayWithObjects:obstacleToSelect, nil]];
}

- (void) deselectAllObstacles {
    [self selectObstacles:[[NSMutableArray alloc] init]];
}

- (void) selectObstaclesWithinHighlight:(b2Shape*)highlightShape {
    NSMutableArray* toSelect = [[NSMutableArray alloc] init];
    
    b2Transform identity;
    identity.SetIdentity();

    // for each obstacle
    for (Obstacle* o in self.obstacles) {
        // if highlight overlaps with obstacle
        if (b2TestOverlap(highlightShape, 0, o.shape, 0, identity, o.body->GetTransform())) {
            // select obstacle
            [toSelect addObject:o];
        }
    }
    
    // select obstacles
    [self selectObstacles:toSelect];
}
@end
