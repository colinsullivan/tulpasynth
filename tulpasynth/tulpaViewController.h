/**
 *  @file       tulpaViewController.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

#include "b2World.h"
#include "b2Contact.h"
#include "b2WorldCallbacks.h"
#include "b2Collision.h"

#include "CollisionDetector.h"
#include "CollisionFilter.h"
#include "Globals.h"

#include "Model.h"

#import "RadialToolbox.h"
#import "Toolbar.h"
#import "SocketHandler.h"
#import "DragSelector.h"


/**
 *  Global audio callback.  userData will be the `tulpaViewController` 
 *  instance.
 **/
void audioCallback(Float32 * buffer, UInt32 numFrames, void * userData);

/**
 *  @class  Master view controller class, handles interactions between
 *  various components in the application, initializes everything, etc.
 **/
@interface tulpaViewController : GLKViewController {
@private
    b2World* _world;
}

/**
 *  Textures used for circles and boxes.
 **/
@property (strong) GLKTextureInfo* glowingCircleTexture;
@property (strong) GLKTextureInfo* glowingBoxTexture;
@property (strong) GLKTextureInfo* shooterTexture;
@property (strong) GLKTextureInfo* shooterGlowingTexture;
@property (strong) GLKTextureInfo* toolboxTexture;
@property (strong) GLKTextureInfo* shooterRadialMenuBackground;
@property (strong) GLKTextureInfo* shooterRadialMenuPointer;
@property (strong) GLKTextureInfo* triObstacleTexture;
@property (strong) GLKTextureInfo* blackholeTexture;
@property (strong) GLKTextureInfo* deleteButtonTexture;
@property (strong) GLKTextureInfo* toolbarTexture;
@property (strong) GLKTextureInfo* addingRingTexture;
@property (strong) GLKTextureInfo* wildBallTexture;
@property (strong) GLKTextureInfo* wildBallGlowTexture;
@property (strong) GLKTextureInfo* receivingShooterTexture;
@property (strong) GLKTextureInfo* receivingShooterGlowingTexture;

/**
 *  Colors 
 **/
@property GLKVector4 greenColor;
@property GLKVector4 orangeColor;
@property GLKVector4 redColor;

/**
 *  Load a texture given a filename (.png assumed).
 *
 *  @param  imageFileName - the name of the image file to load.
 **/
- (GLKTextureInfo*)loadTexture:(NSString*)imageFileName;

/**
 *  OpenGL references.
 **/
@property (strong, nonatomic) EAGLContext * context;
@property (strong, nonatomic) GLKBaseEffect * effect;

/**
 *  `UIGestureRecognizer` instances and handlers for various gestures.
 **/
@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer * pinchRecognizer;
- (IBAction)pinchGestureHandler:(id)sender;

@property (strong, nonatomic) IBOutlet UIRotationGestureRecognizer * rotateRecognizer;
- (IBAction)rotateGestureHandler:(id)sender;

@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer * panRecognizer;
- (IBAction)panGestureHandler:(id)sender;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer * tapRecognizer;
- (IBAction)tapGestureHandler:(id)sender;

@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer * longPressRecognizer;
- (IBAction)longPressHandler:(id)sender;

/**
 *  Box2D world instance.
 **/
@property (readonly) b2World* world;
- (b2World*)world;

/**
 *  Body that represents the left and right walls.
 **/
@property (readonly) b2Body* walls;

/**
 *  This `CollisionDetector` instance will inform us when fixtures have 
 *  collided.
 **/
@property (readonly) CollisionDetector* collisionDetector;

/**
 *  This collision filter ensures that only fixtures with the same
 *  `groupIndex` property will collide.
 **/
@property (readonly) CollisionFilter* collisionFilter;

/**
 *  Called from our `CollisionDetector` when two fixtures begin to touch.
 **/
- (void)beginCollision:(b2Contact*) contact;

/**
 *  The list of obstacle objects currently in creation.
 **/
@property (strong, nonatomic) NSMutableArray * obstacles;

/**
 *  The list of falling balls that are currently instantiated.
 **/
@property (strong, nonatomic) NSMutableArray * fallingBalls;

/**
 *  The list of wild balls currently in play.
 **/
@property (strong, nonatomic) NSMutableArray* wildBalls;

/**
 *  Popup radial toolbox
 **/
@property (strong, nonatomic) RadialToolbox* toolbox;

/**
 *  Slide-in toolbar
 **/
@property (strong, nonatomic) Toolbar* toolbar;

/**
 *  When we started rendering
 **/
@property (strong, nonatomic) NSDate* startTime;

/**
 *  When it is safe to update to
 **/
@property (strong, nonatomic) NSDate* safeUpdateTime;

/**
 *  When was the last time we updated.
 **/
@property (strong, nonatomic) NSDate* lastUpdateTime;



/**
 *  Callback primarily used to handle all model changes and synchronize
 **/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

/**
 *  Socket delegate
 **/
@property (strong, nonatomic) SocketHandler* socketHandler;

/**
 *  List of models that are waiting for ids
 **/
@property (strong, nonatomic) NSMutableArray* waitingForIds;

/**
 *  List of physics entities to destroy next timestep.
 **/
@property (strong, nonatomic) NSMutableArray* physicsEntitiesToDestroy;


/**
 *  List of obstacles currently selected
 **/
@property (strong, nonatomic) NSMutableArray* selectedObstacles;

/**
 *  Called when one or more obstacles is to be selected
 **/
- (void) selectObstacles:(NSMutableArray*)obstaclesToSelect;
/**
 *  Called when a single obstacle is to be selected (proxy to
 *  `obstaclesToSelect`).
 **/
- (void) selectObstacle:(Obstacle*)obstacleToSelect;

/**
 *  Helper method to deselect all currently selected obstacles.
 **/
- (void) deselectAllObstacles;

@property (strong, nonatomic) DragSelector* dragSelector;

/**
 *  Select obstacles within given bounds.  Called by the dragSelector.
 **/
- (void) selectObstaclesWithinHighlight:(b2Shape*)highlightShape;

@end
