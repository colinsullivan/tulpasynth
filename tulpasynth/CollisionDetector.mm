/**
 *  @file       CollisionDetector.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#include <iostream>

#include "CollisionDetector.h"

#import "tulpaViewController.h"


void CollisionDetector::BeginContact(b2Contact* contact) {
    [controller beginCollision:contact];
}

