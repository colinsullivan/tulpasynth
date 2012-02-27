/**
 *  @file       PinchEntity.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#ifndef _PINCHENTITY_H_
#define _PINCHENTITY_H_

#include "GestureEntity.h"

/**
 *  @class Abstraction for a `UIPinchGestureRecognizer`, exposes the scale
 *  of the pinch.
 **/
class PinchEntity : public GestureEntity
{
public:
    PinchEntity(UIPinchGestureRecognizer * aPinchGestureRecognizer);
    ~PinchEntity();

    /**
     *  Scale of pinch as a decimal
     **/
    GLfloat scale;
    
    virtual void update();
};

#endif