/**
 *  @file       PanEntity.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#ifndef _PANENTITY_H_
#define _PANENTITY_H_

#include "GestureEntity.h"

class PanEntity : public GestureEntity
{
public:
    PanEntity(UIPanGestureRecognizer * panRecognizer);
    ~PanEntity();
    
    virtual void update();
    
    /**
     *  Translation vector of amount dragged.
     **/
    b2Vec2 translation;
};

#endif