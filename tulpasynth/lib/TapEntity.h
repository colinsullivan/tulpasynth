/**
 *  @file       TapEntity.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#ifndef _TAPENTITY_H_
#define _TAPENTITY_H_

#include "GestureEntity.h"

class TapEntity : public GestureEntity
{
public:
    TapEntity(UITapGestureRecognizer * tapGesture);
    ~TapEntity();

    virtual void update();
};

#endif