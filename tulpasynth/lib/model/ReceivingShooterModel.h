//
//  ReceivingShooterModel.h
//  tulpasynth
//
//  Created by Colin Sullivan on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShooterModel.h"

@interface ReceivingShooterModel : ShooterModel

/**
 *  Pitch indexes to give to next balls that are shot
 **/
@property (strong, nonatomic) NSMutableArray* nextPitchIndexes;

@end
