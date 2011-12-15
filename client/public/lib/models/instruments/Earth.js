(function() {

  /*
  #   @file       Earth.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  /*
  #   @class  A deep percussive sound.
  */

  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  tulpasynth.models.instruments.Earth = (function() {

    __extends(Earth, tulpasynth.models.instruments.Instrument);

    function Earth() {
      Earth.__super__.constructor.apply(this, arguments);
    }

    Earth.prototype.namespace = 'tulpasynth.models.instruments.Earth';

    Earth.prototype.maxInstances = 4;

    Earth.prototype.initialize = function() {
      if (!this.get('gain')) {
        this.set({
          gain: 0.25
        });
      }
      return Earth.__super__.initialize.apply(this, arguments);
    };

    return Earth;

  })();

}).call(this);
