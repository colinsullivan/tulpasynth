/**
 *  @file       LongPressEntity.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#ifndef _LONGPRESSENTITY_H_
#define _LONGPRESSENTITY_H_

#include "GestureEntity.h"

/**
 *  @class  Encapsulates `UILongPressGestureRecognizer`.  Same as touch 
 *  recognizer currently.
 **/
class LongPressEntity : public GestureEntity
{
public:
    LongPressEntity(UILongPressGestureRecognizer * longPressGesture);
    ~LongPressEntity();
    
    virtual void update();
    
    /**
     *  Translation vector for the amount dragged after a long press.
     **/
    b2Vec2 translation;
private:
    
    /**
     *  The initial position of this gesture.
     **/
    b2Vec2 _initialPosition;
};

#endif