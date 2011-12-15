# tulpasynth

 tulpasynth is a real-time collaborative music creation system.

It was initially developed by Colin Sullivan during the Music 256A [course](https://ccrma.stanford.edu/course-overviews/music-256a) at Stanford's CCRMA.  It is named "tulpasynth" in the spirit of creation without boundaries.

[github.com/colinsullivan/tulpasynth](https://github.com/colinsullivan/tulpasynth)

## Overview
tulpasynth runs in the browser.  Users click on the page to add shapes which represent sounds.  These shapes can be manipulated to modify the sound in various ways.  There is a playhead which loops from left to right, and when it reaches a shape, the server renders the corresponding sound.  The shapes can be manipulated by any connected client at any time.

[Demo of tulpasynth](http://vimeo.com/33702244).  The playhead loops from left to right, sweeping over the shapes in sync with the server creating a specified sound.  Any client connected can modify any of the shapes anonymously.

The application is currently built for collaborative use on a local network, but could easily be translated for use over the internet.  See [future](#future) for more details.

Currently, the application is built using C++ on the backend, and JavaScript on the frontend.  The browsers talk with C++ over websockets, and the C++ server generates the audio and plays it from its own dac.

[Overview of the tulpasynth architecture.](https://ccrma.stanford.edu/~colinsul/projects/tulpasynth/Architecture_Overview.png)

The frontend is written using [Backbone.js](http://documentcloud.github.com/backbone/) for an MVC organization and [Raphael.js](http://raphaeljs.com/) for drawing SVG.

The backend utilizes the elegant [websocketpp](https://github.com/zaphoyd/websocketpp) library to synchronize the models between server and client.

[Dependencies of tulpasynth](https://ccrma.stanford.edu/~colinsul/projects/tulpasynth/Architecture_Dependencies.png)

## Building

To build tulpasynth, download from github, run `./configure` and `make` on the server-side code, then serve the `client/public` folder for the clientside code.

WARNING: `./configure` will clone and build the "Boost" C++ library, which takes quite a while.  If you already have boost installed and don't want to wait, you can edit the `configure` and `Makefile` files accordingly.  This script will also attempt to install the "[jsoncpp](https://github.com/mrtazz/json-cpp" library which requires "[scons](http://www.scons.org/)".

```bash
git clone git://github.com/colinsullivan/tulpasynth.git
cd tulpasynth/server/
# Download and install dependencies.  See above warning.
./configure
make
```

## Running

To use tulpasynth after building is successful, start up the server:

```bash
cd server/
./tulpasynth -a myipaddress
```

Then host the `client/public/` directory with an HTTP server on the same IP address.  I like Marak Squires' "[http-server](https://github.com/nodeapps/http-server", but that requires Node.js.

```bash
cd client/
http-server -a myipaddress
```

Then open a recent [Chrome build](http://www.chromium.org/getting-involved/dev-channel) to http://myipaddress and all should be well :)

## Future
It would be wonderful to spend more time on the graphics, specifically animations.  I like the idea of sound and interaction influencing the visual aesthetics.

This application could be easily modified to send audio remotely and to render it on the client.  The limitations here seem to be figuring out how to optimize uncompressed audio streaming over WebSockets.