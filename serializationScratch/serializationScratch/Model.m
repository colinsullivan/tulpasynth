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

- (NSMutableArray*) serializableAttributes {
    NSMutableArray* attributes = [[NSMutableArray alloc] init];
    
    [attributes addObject:@"id"];
    [attributes addObject:@"name"];
    
    return attributes;
}

- (NSMutableDictionary*) serialize {
    RKObjectMapping* modelMapping = nil;
    static NSError* error = nil;
    
    if (!modelMapping) {
        modelMapping = [RKObjectMapping mappingForClass:[self class]];
        [modelMapping mapAttributesFromArray:[self serializableAttributes]];
    }
    
    RKObjectSerializer* modelSerializer = [RKObjectSerializer serializerWithObject:self mapping:modelMapping];
    NSMutableDictionary* serializedModel = [modelSerializer serializedObject:&error];
    
    if (serializedModel) {
        return serializedModel;
    }
    else {
        NSLog(@"An error occurred while serializing:\n%@", [error localizedDescription]);
        return nil;
    }
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
