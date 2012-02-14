/**
 *  @file       Boing.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#include "Boing.h"

instruments::Boing::Boing() : instruments::RAMpler() {

    NSString* path = [[NSBundle mainBundle] pathForResource:@"boing" ofType:@"wav"];
    const char *filepath = [path UTF8String];

    this->set_clip(filepath);
}