//
//  LongPressEntity.mm
//  tulpasynth
//
//  Created by Colin Sullivan on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
