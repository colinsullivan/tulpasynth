//
//  LongPressEntity.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef _LONGPRESSENTITY_H_
#define _LONGPRESSENTITY_H_

#include "GestureEntity.h"

class LongPressEntity : public GestureEntity
{
public:
    LongPressEntity(UILongPressGestureRecognizer * longPressGesture);
    ~LongPressEntity();
    
    virtual void update();
};

#endif