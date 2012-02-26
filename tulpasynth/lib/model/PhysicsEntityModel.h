//
//  PhysicsEntityModel.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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

- (NSMutableArray*) serializableAttributes;

- (void) initialize;

@end
