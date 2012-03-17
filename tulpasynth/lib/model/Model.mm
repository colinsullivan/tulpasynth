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

@synthesize id, controller, initialized, nosync, ignoreUpdates, destroyed;

- (void) setInitialized:(BOOL)anInitialized {
    if (anInitialized) {
        // add instance to global list
        [[Model Instances] addObject:self];
    }
    
    initialized = anInitialized;
}

- (void) setDestroyed:(NSNumber *)isDestroyed {
    if ([isDestroyed boolValue] == true) {
        try {
            [[Model Instances] removeObject:self];
        } catch (NSException* e) {
            if (e.name == NSRangeException) {
                NSLog(@"NSRangeException occurred during Model Instances removeObject");
            }
            else {
                NSLog(@"other exception occurred during Model Instances removeObject");
            }
        }
    }
    destroyed = isDestroyed;
}

- (id) initWithController:(tulpaViewController*)theController withAttributes:(NSMutableDictionary*)attributes {
//    static int nextId = 0;
    
    if (self = [super init]) {
//        self.id = [[NSNumber alloc] initWithInt:nextId++];
        self.controller = theController;
        
        // De-serialization, instantiation
        NSError* error = nil;
        RKObjectMappingOperation* mapperOperation = [RKObjectMappingOperation mappingOperationFromObject:attributes toObject:self withMapping:[self modelMapping]];
        if (![mapperOperation performMapping:&error]) {
            NSLog(@"An error occurred while applying attributes:\n%@", [error localizedDescription]);
        }

        // by default we will synchronize model
        self.nosync = false;
        
        // by default we will accept all incoming updates
        self.ignoreUpdates = false;
        
        // Set any default attributes
        [self initialize];
        
        // controller should be informed of our creation, and begin watching for changes
//        for (NSString* keyPath in [self serializableAttributes]) {
//            [self addObserver:self.controller forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
//        }
    }
    
    return self;
}

- (void) initialize {
    
    NSMutableDictionary* defaults = [[self class] defaultAttributes];
    
    // for each default attribute
    for (NSString* attributeName in [defaults keyEnumerator]) {
        // if value is not set
        if (![self valueForKey:attributeName]) {
            // set it
            [self setValue:[defaults valueForKey:attributeName] forKey:attributeName];
        }
    }
    
    if (self.id || self.nosync) {
        if(self.nosync) self.id = 0;
        self.initialized = true;
    }
    else {
        self.initialized = false;
        // request ID from the server
        [self.controller.socketHandler send:[NSMutableDictionary dictionaryWithKeysAndObjects:
                                             @"method", @"request_id", nil]];
        [self.controller.waitingForIds addObject:self];            
    }
}

- (NSMutableArray*) serializableAttributes {
    NSMutableArray* attributes = [[NSMutableArray alloc] initWithObjects:@"id", @"destroyed", nil];
    
    return attributes;
}

+ (NSDate*)dateFromString:(NSString*)aString {
    return [NSDate dateWithTimeIntervalSince1970:[aString floatValue]];
}
+ (NSString*)stringFromDate:(NSDate*)aDate {
    return [NSString stringWithFormat:@"%f", [aDate timeIntervalSince1970]];
}

- (RKObjectMapping*) modelMapping {
    RKObjectMapping* modelMapping = nil;
    if (!modelMapping) {
        modelMapping = [RKObjectMapping mappingForClass:[self class]];
        [modelMapping mapAttributesFromArray:[self serializableAttributes]];
        modelMapping.dateFormatters = [NSArray arrayWithObject:[Model class]];
        modelMapping.preferredDateFormatter = [Model class];
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

- (void)deserialize:(NSMutableDictionary *)attributes {
    if (ignoreUpdates) {
        return;
    }
    
    NSError* error;
    RKObjectMappingOperation* mapperOperation = [RKObjectMappingOperation mappingOperationFromObject:attributes toObject:self withMapping:[self modelMapping]];

    [mapperOperation performMapping:&error];
    if (error) {
        NSLog(@"An error occurred while de-serializing:\n%@", [error localizedDescription]);
        exit(-1);
    }
//    else {
//        NSLog(@"Model updated");
//    }
}

+ (ModelCollection*) Instances {
    static ModelCollection* modelInstances = nil;
    
    if (modelInstances == nil) {
        modelInstances = [[ModelCollection alloc] init];
    }
    
    return modelInstances;
}

- (void) synchronize {
    [self.controller.socketHandler synchronizeModel:self];
}

+ (NSMutableDictionary*) defaultAttributes {
    return [NSMutableDictionary dictionaryWithKeysAndObjects:
            @"destroyed", [NSNumber numberWithBool:false]
            , nil];
}

//+ (NSMutableDictionary*) constraints {
//    return [[NSMutableDictionary alloc] init];
//}
//
//- (NSNumber*) constrainAttribute:(NSString*)attributeName value:(NSNumber*)anAttributeValue {
//    
//    NSDictionary* attributeConstraint = [[[self class] constraints] valueForKey:attributeName];
//
//    if (anAttributeValue < [attributeConstraint valueForKey:@"min"]) {
//        anAttributeValue = [attributeConstraint valueForKey:@"min"];
//    }
//    else if (anAttributeValue > [attributeConstraint valueForKey:@"max"]) {
//        anAttributeValue = [attributeConstraint valueForKey:@"max"];
//    }
//    
//    return anAttributeValue;
//}

@end
