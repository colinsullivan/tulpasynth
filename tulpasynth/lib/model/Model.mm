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

#import "tulpaViewController.h"


@implementation Model

@synthesize id, controller;

- (id) initWithController:(tulpaViewController*)theController withAttributes:(NSMutableDictionary*)attributes {
    static int nextId = 0;
    
    if (self = [super init]) {
        self.id = [[NSNumber alloc] initWithInt:nextId++];
        self.controller = theController;
        
        // De-serialization, instantiation
        NSError* error = nil;
        RKObjectMappingOperation* mapperOperation = [RKObjectMappingOperation mappingOperationFromObject:attributes toObject:self withMapping:[self modelMapping]];
        if (![mapperOperation performMapping:&error]) {
            NSLog(@"An error occurred while applying attributes:\n%@", [error localizedDescription]);
        }
        
        // add instance to global list
        [[Model Instances] addObject:self];
        
        // controller should be informed of our creation, and begin watching for changes
        for (NSString* keyPath in [self serializableAttributes]) {
            [self addObserver:self.controller forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
        }
    }
    
    return self;
}

- (NSMutableArray*) serializableAttributes {
    NSMutableArray* attributes = [[NSMutableArray alloc] initWithObjects:@"id", nil];
    
    return attributes;
}

- (RKObjectMapping*) modelMapping {
    RKObjectMapping* modelMapping = nil;
    if (!modelMapping) {
        modelMapping = [RKObjectMapping mappingForClass:[self class]];
        [modelMapping mapAttributesFromArray:[self serializableAttributes]];
    }
    
    return modelMapping;
}

- (NSMutableDictionary*) serialize {
    RKObjectMapping* mapping = [self modelMapping];
    NSError* error = nil;
    
    RKObjectSerializer* modelSerializer = [RKObjectSerializer serializerWithObject:self mapping:mapping];
    NSMutableDictionary* serializedModel = [modelSerializer serializedObject:&error];
    
    if (serializedModel) {
        return serializedModel;
    }
    else {
        NSLog(@"An error occurred while serializing:\n%@", [error localizedDescription]);
        return nil;
    }
}

+ (ModelCollection*) Instances {
    static ModelCollection* modelInstances = nil;
    
    if (modelInstances == nil) {
        modelInstances = [[ModelCollection alloc] init];
    }
    
    return modelInstances;
}

@end
