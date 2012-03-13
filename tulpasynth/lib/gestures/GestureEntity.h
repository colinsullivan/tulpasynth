/**
 *  @file       GestureEntity.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#ifndef _GESTUREENTITY_H_
#define _GESTUREENTITY_H_

#include "b2Math.h"

#include "Globals.h"
#include "TouchEntity.h"


/**
 *  Basic structure for types of gesture states.
 **/
typedef enum {
    GestureEntityStateStart,
    GestureEntityStateUpdate,
    GestureEntityStateEnd
} GestureEntityState;

/**
 *  @class  Base class for all gesture entities.  Used for minor
 *  encapsulation of gesture recognizer properties from Apple.
 **/
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
