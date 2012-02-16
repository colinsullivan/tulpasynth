# tulpasynth

# Colin Sullivan

# 256b: Homework 3: Instrument

## Interaction

This is a musical application that runs on the iPhone.  Currently it is a fairly minimal application in which the user can only perform a small set of actions:

* Single-tap on empty space creates a falling ball object.
* Long-tap on empty space creates a statically positioned rectangular obstacle.
    * Drag on a rectangle moves it to a new location
    * Pinch on a rectangle resizes it proportionally
    * Rotate gesture on a rectangle rotates it

When a ball collides with a rectangle, a sound is triggered.  This is an FM synthesis percussion sound that I synthesized based on a John Chowning paper[^chowning].  The sound utilizes complex amplitude envelopes to achieve the percussive effect.  These envelopes are implemented in lookup tables which were generated using the `CurveTable` object in ChucK.

## Implementation

All of the functionality is initiated from the `tulpaViewController` class, so look there first if you'd like to see how things are working together.  Most of the drawing code is in `PhysicsEntity` and its subclasses, and the gesture handling code for moving the obstacles can be found in the `Obstacle` class.

For more details, see the header files.

[^chowning]: [The Synthesis of Complex Audio Spectra by Means of 
Frequency Modulation, John Chowning, 1973/2007](https://ccrma.stanford.edu/sites/default/files/user/jc/fmsynthesispaperfinal_1.pdf)