/**
 *  @file       TouchEntity.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "b2Math.h"

#ifndef _TOUCHENTITY_H_
#define _TOUCHENTITY_H_

/**
 *  @class Basic touch entity that has a position.  Used by all `GestureEntity`
 *  subclasses.
 **/
class TouchEntity {
public:
    TouchEntity();
    ~TouchEntity();

    b2Vec2 * position;
    GLboolean active;
    UITouch* touch_ref;
};

#endif