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
    
    if (state == GestureEntityStateStart) {
        this->_initialPosition = (*this->touches[0]->position);
    }
    else {
        // calculate translation vector
        this->translation.x = this->touches[0]->position->x - this->_initialPosition.x;
        this->translation.y = this->touches[0]->position->y - this->_initialPosition.y;        
    }
}
