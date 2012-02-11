//
//  Globals.h
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef tulpasynth_Globals_h
#define tulpasynth_Globals_h

typedef struct {
    float Position[3];
    float Color[4];
} Vertex;

#define MAX_TOUCHES 6

#define FRAMESIZE 512
#define NUM_CHANNELS 2

#define M_TO_PX(meters) meters*3

#endif
