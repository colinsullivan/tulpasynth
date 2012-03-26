/**
 *  @file       TrigLookupTables.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

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
