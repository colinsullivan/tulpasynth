/**
 *  @file       PanEntity.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#ifndef _PANENTITY_H_
#define _PANENTITY_H_

#include "GestureEntity.h"

/**
 *  @class Abstraction for a `UIPanGestureRecognizer`.  Exposes distance 
 *  dragged.
 **/
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
    
    /**
     *  Velocity vector of dragging.
     **/
    b2Vec2 velocity;
};

#endif