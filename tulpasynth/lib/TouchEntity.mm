/**
 *  @file       TouchEntity.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "TouchEntity.h"

TouchEntity::TouchEntity() {
    active = false;
    touch_ref = NULL;
    position = new b2Vec2();
}

TouchEntity::~TouchEntity() {
    delete position;
}