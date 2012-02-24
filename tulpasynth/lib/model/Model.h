/**
 *  @file       Model.h
 *              tulpasynth
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/


#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface Model : NSObject


@property (nonatomic, retain) NSNumber* id;

- (id) init;

- (NSMutableArray*) serializableAttributes;
- (NSMutableDictionary*) serialize;



@end
