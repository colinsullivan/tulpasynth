//
//  ModelCollection.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
 *  Retreive a model instance by id
 **/
- (Model*)getById:(NSString*)anId;

@end
