/**
 *  @file       CollisionDetector.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/


#ifndef tulpasynth_CollisionDetector_hpp
#define tulpasynth_CollisionDetector_hpp

#include "b2WorldCallbacks.h"

#import "tulpaViewController.h"

/**
 *  @class  Wrapper class around `b2ContactListener` so collision callbacks
 *  can be forwarded to the view controller.
 **/
class CollisionDetector : public b2ContactListener {    

public:
    CollisionDetector(id* theController) {
        b2ContactListener::b2ContactListener();

        this->controller = theController;
    }
    ~CollisionDetector() {
        b2ContactListener::~b2ContactListener();
    }
    
    /**
     *  Called when two fixtures begin to touch.
     **/
    void BeginContact(b2Contact* contact) {
        [(id)controller beginCollision:contact];
    }

private:
    
    id* controller;
    
};

#endif
