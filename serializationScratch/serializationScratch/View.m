//
//  View.m
//  serializationScratch
//
//  Created by Colin Sullivan on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "View.h"

@implementation View

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    NSLog(@"View.observeValueForKeyPath\n\tkeyPath:\t%@\n\tchange:\t%@", keyPath, change);
    
}

- (void) startObservingKeyPaths:(NSArray*)keyPaths ofObject:(id)object {
    for (NSString* keyPath in keyPaths) {
        [object addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:NULL];
    }
}

@end
