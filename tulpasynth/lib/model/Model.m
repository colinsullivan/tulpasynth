/**
 *  @file       Model.m
 *              tulpasynth
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "Model.h"

@implementation Model

@synthesize id;

- (id) init {
    
    static int nextId = 0;
    
    if (self = [super init]) {
        self.id = [[NSNumber alloc] initWithInt:nextId++];
    }
    
    return self;
}

- (NSMutableArray*) serializableAttributes {
    NSMutableArray* attributes = [[NSMutableArray alloc] initWithObjects:@"id", nil];
    
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

@end
