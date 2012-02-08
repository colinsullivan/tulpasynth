/**
 *  @file       RotateEntity.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#include "RotateEntity.h"

RotateEntity::RotateEntity(UIRotationGestureRecognizer* rotateRecognizer) {
    GestureEntity::GestureEntity();

    gestureRecognizer = rotateRecognizer;
}

RotateEntity::~RotateEntity() {
    GestureEntity::~GestureEntity();
    
}

void RotateEntity::update() {
    GestureEntity::update();
    
    rotation = ((UIRotationGestureRecognizer *)gestureRecognizer).rotation;
}