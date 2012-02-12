//
//  TouchEntity.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TouchEntity.h"

//@implementation TouchEntity
//
//@synthesize active;
//@synthesize touch_ref;
//
//- (id)init {
//    
//    if (self = [super init]) {
//
//        active = false;
//        touch_ref = NULL;
//
//    }
//
//    
//    return self;
//}
//
//@end

TouchEntity::TouchEntity() {
    active = false;
    touch_ref = NULL;
    position = new b2Vec2();
}

TouchEntity::~TouchEntity() {
    delete position;
}