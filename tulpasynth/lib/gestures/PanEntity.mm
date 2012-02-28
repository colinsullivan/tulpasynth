/**
 *  @file       PanEntity.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
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
    
    UIPanGestureRecognizer* gesture = ((UIPanGestureRecognizer *)gestureRecognizer);

    CGPoint temp = [gesture translationInView:nil];
    this->translation.x = PX_TO_M(temp.y);
    this->translation.y = PX_TO_M(temp.x);
    
    CGPoint tempVelocity = [gesture velocityInView:nil];
    // transform velocity vector and save in m/s
    this->velocity.x = PX_TO_M(tempVelocity.y);
    this->velocity.y = PX_TO_M(tempVelocity.x);
    
}
