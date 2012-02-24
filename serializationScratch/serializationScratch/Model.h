//
//  Model.h
//  serializationScratch
//
//  Created by Colin Sullivan on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface Model : NSObject


@property (nonatomic, retain) NSNumber* id;
@property (nonatomic, retain) NSString* name;

- (id) init;

- (NSMutableArray*) serializableAttributes;
- (NSMutableDictionary*) serialize;



@end
