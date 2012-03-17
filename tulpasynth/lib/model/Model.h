/**
 *  @file       Model.h
 *              tulpasynth
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/


#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

#import "ModelCollection.h"

@class tulpaViewController;

@interface Model : NSObject

@property (nonatomic, retain) NSNumber* id;
@property (nonatomic, assign) tulpaViewController* controller;
/**
 *  Wether or not this model is currently alive.  When set to true,
 *  model instance will be destroyed.
 **/
@property (nonatomic, assign) NSNumber* destroyed;

- (id) initWithController:(tulpaViewController*)theController withAttributes:(NSMutableDictionary*)attributes;

/**
 *  Override in subclasses to initialize default attributes;
 **/
- (void) initialize;

/**
 *  Has this model finished initializing? (i.e. received an id from the server)
 **/
@property (nonatomic) BOOL initialized;

- (NSMutableArray*) serializableAttributes;
- (NSMutableDictionary*) serialize;
- (void) deserialize:(NSMutableDictionary*)attributes;

/**
 *  A global list of all model instances.
 **/
+ (ModelCollection*) Instances;

/**
 *  `RKObjectMapping` instance for this object.  Used for 
 *  serialization/de-serialization.
 **/
- (RKObjectMapping*) modelMapping;

/**
 *  When this model is to be synchronized across nodes.
 **/
- (void) synchronize;

/**
 *  Default attributes for this model.
 **/
+ (NSMutableDictionary*) defaultAttributes;

/**
 *  Wether or not to track this model for synchronization changes
 **/
@property BOOL nosync;

/**
 *  Static helper method for parsing dates.
 **/
+ (NSDate*) dateFromString:(NSString*)aString;
+ (NSString*) stringFromDate:(NSDate*)aDate;

/**
 *  If updates should be ignored on this model (i.e. if the user is currently
 *  changing it via GUI)
 **/
@property BOOL ignoreUpdates;

@end
