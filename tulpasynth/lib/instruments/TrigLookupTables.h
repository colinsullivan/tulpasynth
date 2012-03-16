//
//  TrigLookupTables.h
//  tulpasynth
//
//  Created by Colin Sullivan on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef tulpasynth_TrigLookupTables_h
#define tulpasynth_TrigLookupTables_h

#include "Stk.h"
#include <math.h>

class TrigLookupTables {
public:
    static stk::StkFloat SIN_LOOKUP[10001];
    
    /**
     *  Should be called once.
     **/
    static void generate();
};


#endif
