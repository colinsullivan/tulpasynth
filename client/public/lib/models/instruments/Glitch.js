(function() {

  /*
  #   @file       Glitch.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  var Instrument;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  Instrument = tulpasynth.models.instruments.Instrument;

  /*
  #   @class  Small percussive hit.
  */

  tulpasynth.models.instruments.Glitch = (function() {

    __extends(Glitch, Instrument);

    function Glitch() {
      Glitch.__super__.constructor.apply(this, arguments);
    }

    Glitch.prototype.namespace = "tulpasynth.models.instruments.Glitch";

    Glitch.prototype.maxInstances = 25;

    return Glitch;

  })();

}).call(this);
