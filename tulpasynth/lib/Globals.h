/**
 *  @file       Globals.h
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#ifndef tulpasynth_Globals_h
#define tulpasynth_Globals_h

/**
 *  @struct Basic data structure for OpenGL vertices.
 **/
typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2];
} Vertex;

#define MAX_TOUCHES 6

#define FRAMESIZE 512
#define NUM_CHANNELS 2

#define PX_PER_M 2

/**
 *  Macros for converting between meters and pixels.
 **/
#define M_TO_PX(meters) meters*PX_PER_M
#define PX_TO_M(px) px/PX_PER_M

#endif
