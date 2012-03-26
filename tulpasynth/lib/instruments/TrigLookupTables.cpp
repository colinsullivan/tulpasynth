/**
 *  @file       TrigLookupTables.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#include <iostream>

#include "TrigLookupTables.h"

stk::StkFloat TrigLookupTables::SIN_LOOKUP[10001];

void TrigLookupTables::generate() {
    for (int i = 0; i < 10001; i++) {
        TrigLookupTables::SIN_LOOKUP[i] = sinf(stk::TWO_PI * (i/10000.0));
    }
}