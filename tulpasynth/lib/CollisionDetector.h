/**
 *  @file       CollisionDetector.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#include "b2WorldCallbacks.h"

@class tulpaViewController;

#ifndef __COLLISIONDETECTOR_H_
#define __COLLISIONDETECTOR_H_

/**
 *  @class  Wrapper class around `b2ContactListener` so collision callbacks
 *  can be forwarded to the view controller.
 **/
class CollisionDetector : public b2ContactListener {    

public:
    CollisionDetector(tulpaViewController* theController) {
        b2ContactListener::b2ContactListener();

        this->controller = theController;
    }
    ~CollisionDetector() {
        b2ContactListener::~b2ContactListener();
    }
    
    /**
     *  Called when two fixtures begin to touch.
     **/
    void BeginContact(b2Contact* contact);

private:
    
    tulpaViewController* controller;
    
};

#endif
