/**
 *  @file       PanEntity.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#include "PanEntity.h"

PanEntity::PanEntity(UIPanGestureRecognizer * panRecognizer) {
    GestureEntity::GestureEntity();
    
    gestureRecognizer = panRecognizer;
}
PanEntity::~PanEntity() {
    GestureEntity::~GestureEntity();
}

void PanEntity::update() {
    GestureEntity::update();

    CGPoint temp = [((UIPanGestureRecognizer *)gestureRecognizer) translationInView:nil];
    // transform: to make landscape
    double tempx = temp.x;
    temp.x = temp.y;
    temp.y = tempx;

    
    this->translation.x = temp.x;
    this->translation.y = temp.y;
}
