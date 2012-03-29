# tulpasynth

tulpasynth is a real-time collaborative music creation system.


It was initially developed by Colin Sullivan during the Music 256A course at Stanford's CCRMA, and was later rebuilt using different technologies for 256B.  It is named "tulpasynth" in the spirit of creation without boundaries.

[github.com/colinsullivan/tulpasynth](https://github.com/colinsullivan/tulpasynth)

## Overview
tulpasynth is an abstract interface for users to collaboratively create music together.  The most recent version has a user interface written in iOS using OpenGL, and communicates with the Node.js server via websockets.

It looks something like this:

[https://ccrma.stanford.edu/~colinsul/projects/tulpasynth/tulpasynth_scene_01.png](https://ccrma.stanford.edu/~colinsul/projects/tulpasynth/tulpasynth_scene_01.png)

Here is a demo video:

[https://vimeo.com/39234533](https://vimeo.com/39234533)

## Goals
To enable _spontaneous creation_ by responding to familiar touchscreen gestures and requiring only simple interaction paradigms to manipulate the entities in the application.

Users build systems with _emerging complexity_ as they add/manipulate primitive entities in the system and connect them together.

## Interaction
tulpasynth runs on an iOS device.  Users tap in the empty space to add objects to the screen, which may create flying "balls" that collide with other objects and make sound when they collide.  The pitch of these balls can be manipulated with other entities, and they can also be "teleported" to another player's screen.

## Implementation
The UI is written in Objective-C and utilizes Cocoa's `NSKeyValueObserving` and `NSKeyValueCoding` protocols to provide event callbacks for a Model-View pattern.  The model data is synchronized over a websocket using Square's SocketStream library, and Node.js handles some simple manipulations on the models to send the proper information to other clients.

The graphics are written in OpenGL, and are slaved to the Box2D physics engine for motion.

## Building

```bash
git clone git@github.com:colinsullivan/tulpasynth.git
cd tulpasynth/
./configure
```

To run tulpasynth client open `tulpasynth.xcodeproj`, select "tulpasynth" as the build target, and run.  You'll need to configure your tulpasynth server's IP and port in the tulpasynth preferences in the device's settings.

To run the server after starting redis,

```bash
cd server/
./main.coffee --address=myipaddress --port=myport
```

## Future
After a few iterations trying different interactions and synchronization schemes, I think this project is on the right track in terms of the original high-level goals stated above.  I would love to experiment more with the physics engine and with creating  "Rube Goldberg" like systems that users can pass the results of to one another, and really feel like they are creating music together.

## v0.1
More information on v0.1 of tulpasynth, which was developed using different technologies, can be found here: [ccrma.stanford.edu/~colinsul/projects/tulpasynth_v01](http://ccrma.stanford.edu/~colinsul/projects/tulpasynth_v01)