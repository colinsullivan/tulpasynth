//
//  WildBall.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "b2Fixture.h"
#include "b2CircleShape.h"
#include "b2Body.h"


#import "PhysicsEntity.h"
#import "WildBallModel.h"


@interface WildBall : PhysicsEntity

- (void) setWidth:(float)width;
- (void) initialize;
- (b2BodyType)bodyType;
-(void)prepareToDraw;

@end
