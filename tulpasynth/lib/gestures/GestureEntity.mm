/**
 *  @file       GestureEntity.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
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
    // HACK: This ignores other touches 
    for (int i = 0; i < MIN([gestureRecognizer numberOfTouches], 2); i++) {
        location = [gestureRecognizer locationOfTouch:i inView:nil];
        
        // transform: to make landscape
        touches[i]->position->Set(PX_TO_M(location.y), PX_TO_M(location.x));
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