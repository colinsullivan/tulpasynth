//
//  View.h
//  serializationScratch
//
//  Created by Colin Sullivan on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Model.h"

@class tulpaViewController;

@interface View : NSObject

@property (strong, nonatomic) Model* model;
@property (assign, nonatomic) tulpaViewController* controller;


/**
 *  Helper method to begin observing an object
 **/
- (void) startObservingKeyPaths:(NSArray*)keyPaths ofObject:(id)object;

/**
 *  Observer callback that is fired when an object we're observing changes.
 **/
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

/**
 *  Use this function when instantiating any views.
 **/
- (id)initWithController:(tulpaViewController *)theController withModel:(Model*)aModel;

/**
 *  Override this function in view subclasses to handle initialization.
 **/
- (void) initialize;
@end
