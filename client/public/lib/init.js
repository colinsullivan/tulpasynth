(function() {

  /*
  #   @file       init.coffee
  #
  #               This file contains initialization code for various
  #               things.  It is the first file loaded.
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  var ADDRESS;

  ADDRESS = window.location.hostname;

  window.tulpasynth = {
    views: {
      instrumentcontrollers: {}
    },
    models: {
      instruments: {},
      waitingInstances: []
    },
    socket: null,
    orchestra: null,
    canvas: null,
    timeline: null
  };

  $(document).ready(function() {
    tulpasynth.canvas = Raphael($('#canvas').get(0), $('#canvas').width(), $('#canvas').height());
    tulpasynth.orchestra = new tulpasynth.models.Orchestra({
      id: 1
    });
    tulpasynth.timeline = new tulpasynth.views.Timeline();
    return tulpasynth.socket = new tulpasynth.SocketHelper("ws://" + ADDRESS + ":9090");
  });

  window.tulpasynth.create_sequencer = function() {
    var glitchInstance, i, _i, _len, _ref, _results;
    _ref = [0.0546875, 0.166015625, 0.27734375, 0.388671875, 0.5, 0.611328125, 0.72265625, 0.833984375, 0.9453125];
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      _results.push(glitchInstance = new tulpasynth.models.instruments.Glitch({
        startTime: i,
        disabled: true
      }));
    }
    return _results;
  };

}).call(this);
