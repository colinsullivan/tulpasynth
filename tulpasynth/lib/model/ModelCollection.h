/**
 *  @file       ModelCollection.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import <Foundation/Foundation.h>

@class Model;

@interface ModelCollection : NSObject

@property (nonatomic, retain) NSMutableArray* objects;
@property (nonatomic, retain) NSMutableDictionary* objectsById;

- (id)init;

/**
 *  Add model instance to this collection.  WARNING: id of instance should
 *  be set first.
 **/
- (void)addObject:(Model*)anObject;

/**
 *  Remove model instance from this collection.
 **/
- (void)removeObject:(Model*)anObject;

/**
 *  Retreive a model instance by id
 **/
- (Model*)getById:(NSNumber*)anId;

@end
