(function() {

  /*
  #   @file       DistortedSnare.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  /*
  #   @class  Distorted percussive snare
  */

  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  tulpasynth.models.instruments.DistortedSnare = (function() {

    __extends(DistortedSnare, tulpasynth.models.instruments.Instrument);

    function DistortedSnare() {
      DistortedSnare.__super__.constructor.apply(this, arguments);
    }

    DistortedSnare.prototype.namespace = 'tulpasynth.models.instruments.DistortedSnare';

    DistortedSnare.prototype.maxInstances = 4;

    DistortedSnare.prototype.initialize = function() {
      if (!this.get('gain')) {
        this.set({
          gain: 0.3
        });
      }
      return DistortedSnare.__super__.initialize.apply(this, arguments);
    };

    return DistortedSnare;

  })();

}).call(this);
