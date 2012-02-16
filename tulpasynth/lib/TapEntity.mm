/**
 *  @file       TapEntity.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#include "TapEntity.h"

TapEntity::TapEntity(UITapGestureRecognizer * tapGesture) {
    GestureEntity::GestureEntity();
    
    gestureRecognizer = tapGesture;
}
TapEntity::~TapEntity() {
    
}

void TapEntity::update() {
    GestureEntity::update();
}
