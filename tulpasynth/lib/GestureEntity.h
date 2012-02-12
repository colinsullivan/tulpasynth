/**
 *  @file       GestureEntity.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#ifndef _GESTUREENTITY_H_
#define _GESTUREENTITY_H_

#include "b2Math.h"

#include "Globals.h"
#include "TouchEntity.h"


typedef enum {
    GestureEntityStateStart,
    GestureEntityStateMove,
    GestureEntityStateEnd
} GestureEntityState;


class GestureEntity
{
public:
    GestureEntity();
    ~GestureEntity();

    virtual void update();

    GestureEntityState state;

    TouchEntity * touches[2];
protected:
    
    UIGestureRecognizer * gestureRecognizer;

};

#endif
