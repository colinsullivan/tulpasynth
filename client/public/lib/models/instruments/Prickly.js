(function() {

  /*
  #   @file       Prickly.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  /*
  #   @class  Prickly instrument
  */

  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  tulpasynth.models.instruments.Prickly = (function() {

    __extends(Prickly, tulpasynth.models.instruments.PitchedInstrument);

    function Prickly() {
      Prickly.__super__.constructor.apply(this, arguments);
    }

    Prickly.prototype.namespace = 'tulpasynth.models.instruments.Prickly';

    Prickly.prototype.maxInstances = 6;

    Prickly.prototype.initialize = function(attributes) {
      this.minPitchIndex = 16;
      if (!this.get('gain')) {
        this.set({
          gain: 0.30
        });
      }
      return Prickly.__super__.initialize.apply(this, arguments);
    };

    return Prickly;

  })();

}).call(this);
