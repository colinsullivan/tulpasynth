/**
 *  @file       GestureEntity.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#include "GestureEntity.h"

GestureEntity::GestureEntity() {
    touches[0] = new TouchEntity();
    touches[1] = new TouchEntity();
}

GestureEntity::~GestureEntity() {
    delete touches[0];
    delete touches[1];
}

void GestureEntity::update() {
    // Update touch entities
    CGPoint location;
    double temp;
    for (int i = 0; i < 2; i++) {
        location = [gestureRecognizer locationOfTouch:i inView:nil];
        
        // transform: to make landscape
        temp = location.x;
        location.x = location.y;
        location.y = temp;
        
        touches[i]->position->set(location.x, location.y, 0);
    }
    
    // update state
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        state = GestureEntityStateStart;
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        state = GestureEntityStateMove;
    }
    else {
        state = GestureEntityStateEnd;
    }

}