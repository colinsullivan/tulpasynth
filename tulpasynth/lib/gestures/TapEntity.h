/**
 *  @file       TapEntity.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#ifndef _TAPENTITY_H_
#define _TAPENTITY_H_

#include "GestureEntity.h"

/**
 *  @class  Abstraction around a `UITapGestureRecognizer`.  Doesn't really
 *  expose anything other than a `GestureEntity`.
 **/
class TapEntity : public GestureEntity
{
public:
    TapEntity(UITapGestureRecognizer * tapGesture);
    ~TapEntity();

    virtual void update();
};

#endif