/**
 *  @file       PinchEntity.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#include "PinchEntity.h"

PinchEntity::PinchEntity(UIPinchGestureRecognizer * aPinchGestureRecognizer) {
    GestureEntity::GestureEntity();

    gestureRecognizer = aPinchGestureRecognizer;
}

PinchEntity::~PinchEntity() {
    GestureEntity::~GestureEntity();
}

void PinchEntity::update() {
    GestureEntity::update();
    
    // update scale
    scale = ((UIPinchGestureRecognizer *)gestureRecognizer).scale;
}