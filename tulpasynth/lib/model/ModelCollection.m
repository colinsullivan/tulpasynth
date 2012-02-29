//
//  ModelCollection.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ModelCollection.h"

@implementation ModelCollection

@synthesize objects;

- (id)init {
    if (self = [super init]) {
        self.objects = [[NSMutableArray alloc] init];
    }
    
    return self;
}

//- (void)dealloc {
//    [self.objects dealloc];
//}

- (void)addObject:(id)anObject {
    NSIndexSet* insertIndex = [NSIndexSet indexSetWithIndex:[self.objects count]];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:insertIndex  forKey:@"objects"];
    
    [[self objects] addObject:anObject];
    
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:insertIndex forKey:@"objects"];
}

@end
