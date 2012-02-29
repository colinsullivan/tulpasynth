//
//  CollisionDetector.cpp
//  tulpasynth
//
//  Created by Colin Sullivan on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <iostream>

#include "CollisionDetector.h"

#import "tulpaViewController.h"


void CollisionDetector::BeginContact(b2Contact* contact) {
    [controller beginCollision:contact];
}

