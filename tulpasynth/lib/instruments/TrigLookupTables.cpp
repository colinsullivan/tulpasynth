//
//  TrigLookupTables.cpp
//  tulpasynth
//
//  Created by Colin Sullivan on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <iostream>

#include "TrigLookupTables.h"

stk::StkFloat TrigLookupTables::SIN_LOOKUP[10001];

void TrigLookupTables::generate() {
    for (int i = 0; i < 10001; i++) {
        TrigLookupTables::SIN_LOOKUP[i] = sinf(stk::TWO_PI * (i/10000.0));
    }
}