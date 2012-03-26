/**
 *  @file       PhysicsEntityModel.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "Model.h"

/**
 *  An abstract model class that encapsulates any physics data pertaining to
 *  all types of PhysicsEntities.
 **/
@interface PhysicsEntityModel : Model

@property (strong, nonatomic) NSDictionary* initialPosition;
@property (strong, nonatomic) NSNumber* angle;
@property (strong, nonatomic) NSNumber* height;
@property (strong, nonatomic) NSNumber* width;
@property (strong, nonatomic) NSMutableDictionary* position;

@end
