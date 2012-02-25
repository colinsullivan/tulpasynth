//
//  ModelCollection.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelCollection : NSObject

@property (nonatomic, retain) NSMutableArray* objects;

- (id)init;

- (void)addObject:(id)anObject;

@end
