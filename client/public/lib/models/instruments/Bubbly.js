(function() {

  /*
  #   @file       Bubbly.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  /*
  #   @class  Short bubbly percussive sound.
  */

  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  tulpasynth.models.instruments.Bubbly = (function() {

    __extends(Bubbly, tulpasynth.models.instruments.PitchedInstrument);

    function Bubbly() {
      Bubbly.__super__.constructor.apply(this, arguments);
    }

    Bubbly.prototype.namespace = "tulpasynth.models.instruments.Bubbly";

    Bubbly.prototype.maxInstances = 8;

    Bubbly.prototype.initialize = function(attributes) {
      this.maxPitchIndex = 14;
      if (!this.get('gain')) {
        this.set({
          'gain': 1.5
        });
      }
      return Bubbly.__super__.initialize.apply(this, arguments);
    };

    return Bubbly;

  })();

}).call(this);
