//
//  ModelCollection.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ModelCollection.h"

#import "Model.h"

@implementation ModelCollection

@synthesize objects, objectsById;

- (id)init {
    if (self = [super init]) {
        self.objects = [[NSMutableArray alloc] init];
        self.objectsById = [NSMutableDictionary dictionary];
    }
    
    return self;
}

//- (void)dealloc {
//    [self.objects dealloc];
//}


- (void)addObject:(Model*)anObject {
    NSIndexSet* insertIndex = [NSIndexSet indexSetWithIndex:[self.objects count]];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:insertIndex  forKey:@"objects"];
    [[self objects] addObject:anObject];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:insertIndex forKey:@"objects"];
    
    [self.objectsById setObject:anObject forKey:anObject.id];
}

- (Model*)getById:(NSNumber*)anId {
    Model* m = [self.objectsById objectForKey:anId];
    return m;
}

@end
