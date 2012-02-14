//
//  CollisionDetector.hpp
//  tulpasynth
//
//  Created by Colin Sullivan on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef tulpasynth_CollisionDetector_hpp
#define tulpasynth_CollisionDetector_hpp

#import "tulpaViewController.h"

#include "b2WorldCallbacks.h"

class CollisionDetector : public b2ContactListener {    

public:
    CollisionDetector(id* theController) {
        b2ContactListener::b2ContactListener();

        this->controller = theController;
    }
    ~CollisionDetector() {
        
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
