/**
 *  @file       PinchEntity.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#include "PinchEntity.h"

PinchEntity::PinchEntity() {
    touches[0] = new TouchEntity();
    touches[1] = new TouchEntity();
    
    pinch_ref = NULL;
}

PinchEntity::~PinchEntity() {
    delete touches[0];
    delete touches[1];
}

void PinchEntity::set(UIPinchGestureRecognizer* aPinchRecognizer) {
    pinch_ref = aPinchRecognizer;
}

void PinchEntity::update() {
    // Update touch entities
    CGPoint location;
    double temp;
    for (int i = 0; i < 2; i++) {
        location = [pinch_ref locationOfTouch:i inView:nil];

        // transform: to make landscape
        temp = location.x;
        location.x = location.y;
        location.y = temp;
        
        touches[i]->position->set(location.x, location.y, 0);
    }

    //    UIGestureRecognizerStatePossible,   // the recognizer has not yet recognized its gesture, but may be evaluating touch events. this is the default state
//    
//    UIGestureRecognizerStateBegan,      // the recognizer has received touches recognized as the gesture. the action method will be called at the next turn of the run loop
//    UIGestureRecognizerStateChanged,    // the recognizer has received touches recognized as a change to the gesture. the action method will be called at the next turn of the run loop
//    UIGestureRecognizerStateEnded,      // the recognizer has received touches recognized as the end of the gesture. the action method will be called at the next turn of the run loop and the recognizer will be reset to UIGestureRecognizerStatePossible
//    UIGestureRecognizerStateCancelled,  // the recognizer has received touches resulting in the cancellation of the gesture. the action method will be called at the next turn of the run loop. the recognizer will be reset to UIGestureRecognizerStatePossible
//    
//    UIGestureRecognizerStateFailed,     // the recognizer has received a touch sequence that can not be recognized as the gesture. the action method will not be called and the recognizer will be reset to UIGestureRecognizerStatePossible
//    
//    // Discrete Gestures – gesture recognizers that recognize a discrete event but do not report changes (for example, a tap) do not transition through the Began and Changed states and can not fail or be cancelled
//    UIGestureRecognizerStateRecognized = UIGestureRecognizerStateEnded // the reco

    // update state
    if (pinch_ref.state == UIGestureRecognizerStateBegan) {
        state = PinchEntityStateStart;
    }
    else if(pinch_ref.state == UIGestureRecognizerStateChanged) {
        state = PinchEntityStateMove;
    }
    else {
        state = PinchEntityStateEnd;
    }
    
    // update scale
    scale = pinch_ref.scale;
}