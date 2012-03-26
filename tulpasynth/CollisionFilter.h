/**
 *  @file       CollisionFilter.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#ifndef tulpasynth_CollisionFilter_h
#define tulpasynth_CollisionFilter_h

#include "b2WorldCallbacks.h"

class CollisionFilter : public b2ContactFilter {
public:
    
    CollisionFilter() {
        b2ContactFilter::b2ContactFilter();
    }
    ~CollisionFilter() {
        b2ContactFilter::~b2ContactFilter();
    }
    
    /**
     *  Determine if two objects should collide entirely on groupIndex value.
     **/
    inline virtual bool ShouldCollide(b2Fixture* fixtureA, b2Fixture* fixtureB) {
        const b2Filter& filterA = fixtureA->GetFilterData();
        const b2Filter& filterB = fixtureB->GetFilterData();
        
        return filterA.groupIndex == filterB.groupIndex;
    }
};

#endif
