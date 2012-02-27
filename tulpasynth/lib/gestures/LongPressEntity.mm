/**
 *  @file       LongPressEntity.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#include "LongPressEntity.h"

LongPressEntity::LongPressEntity(UILongPressGestureRecognizer * longPressGesture) {
    GestureEntity::GestureEntity();
    
    gestureRecognizer = longPressGesture;
}
LongPressEntity::~LongPressEntity() {
    
}

void LongPressEntity::update() {
    GestureEntity::update();
}
