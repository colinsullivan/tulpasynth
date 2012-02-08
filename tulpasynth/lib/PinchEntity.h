/**
 *  @file       PinchEntity.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#ifndef _PINCHENTITY_H_
#define _PINCHENTITY_H_

#include "TouchEntity.h"

typedef enum {
    PinchEntityStateStart,
    PinchEntityStateMove,
    PinchEntityStateEnd
} PinchEntityState;

class PinchEntity
{
public:
    PinchEntity();
    ~PinchEntity();
    
    void set(UIPinchGestureRecognizer* aPinchRecognizer);
    void update();

    TouchEntity * touches[2];
    
    PinchEntityState state;
    
    UIPinchGestureRecognizer * pinch_ref;
    
    GLfloat scale;
};

#endif