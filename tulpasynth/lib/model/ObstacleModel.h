//
//  ObstacleModel.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhysicsEntityModel.h"

@interface ObstacleModel : PhysicsEntityModel

@property (strong, nonatomic) NSMutableDictionary* position;
@property (strong, nonatomic) NSNumber* angle;

- (NSMutableArray*) serializableAttributes;

@end
