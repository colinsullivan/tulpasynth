/**
 *  @file       PhysicsEntity.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>

#include "Globals.h"

#import "View.h"
#import "PhysicsEntityModel.h"

#include "b2Body.h"


/**
 *  @class Base class for all graphics entities, all of which are subject
 *  to Box2D physics.
 **/
@interface PhysicsEntity : View {
    
@protected
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    
}


/**
 *  Callback used when model changes
 **/
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

@property b2Body* body;

/**
 *  Keep reference to outermost shape for border detection.
 **/
@property b2Shape* shape;
@property b2Fixture* shapeFixture;

/**
 *  Width and height of this object (in world coordinates)
 **/
@property float width;
@property float height;

/**
 *  Rotation of this object (in radians)
 **/
@property (nonatomic) float32 angle;


/**
 *  Hook into b2Body::GetPosition.  Setting the position from here
 *  will not do anything.
 **/
@property const b2Vec2& position;



@property (strong, nonatomic) GLKBaseEffect * effect;

- (void) initialize;

- (void)prepareToDraw;
- (void)draw;
- (void)postDraw;

- (void)update;

/**
 *  Override getter for position so we can hook into b2Body::GetPosition.
 **/
- (const b2Vec2&)position;
- (void)setPosition:(const b2Vec2 &)aPosition;

/**
 *  Static list of all physics entity instances.
 **/
+ (NSMutableArray*) Instances;

/**
 *  Static method for defining body type.  Should be overridden in child
 *  classes that wish to be dynamic bodies.
 **/
- (b2BodyType)bodyType;

@end
