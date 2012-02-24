//
//  View.h
//  serializationScratch
//
//  Created by Colin Sullivan on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Model.h"

@interface View : NSObject

/**
 *  Helper method to begin observing an object
 **/
- (void) startObservingKeyPaths:(NSArray*)keyPaths ofObject:(id)object;

/**
 *  Observer callback that is fired when an object we're observing changes.
 **/
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

@end
