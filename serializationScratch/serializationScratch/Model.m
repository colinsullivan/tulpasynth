//
//  Model.m
//  serializationScratch
//
//  Created by Colin Sullivan on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Model.h"

@implementation Model

@synthesize id, name;

- (id) init {
    
    static int nextId = 0;
    
    if (self = [super init]) {
        self.id = [[NSNumber alloc] initWithInt:nextId++];
    }
    
    return self;
}

//@synthesize attributes;
//
//- (id)init {
//    if (self = [super init]) {
//        self.attributes = [[NSMutableDictionary alloc] init];
//    }
//    
//    return self;
//}

@end
