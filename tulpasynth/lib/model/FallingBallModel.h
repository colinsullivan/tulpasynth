//
//  FallingBallModel.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Model.h"

@interface FallingBallModel : Model

@property (strong, nonatomic) NSDictionary* initialPosition;

- (id) initWithPosition:(NSDictionary*)aPosition;

@end
