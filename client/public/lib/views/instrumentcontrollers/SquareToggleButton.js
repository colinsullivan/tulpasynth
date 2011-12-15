(function() {

  /*
  #   @file       SquareToggleButton.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  /*
  #   @class  Square that can be toggled on and off.
  */

  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  tulpasynth.views.instrumentcontrollers.SquareToggleButton = (function() {

    __extends(SquareToggleButton, tulpasynth.views.instrumentcontrollers.InstrumentController);

    function SquareToggleButton() {
      SquareToggleButton.__super__.constructor.apply(this, arguments);
    }

    SquareToggleButton.prototype.initialize = function(options) {
      return SquareToggleButton.__super__.initialize.apply(this, arguments);
    };

    SquareToggleButton.prototype.render = function() {
      SquareToggleButton.__super__.render.apply(this, arguments);
      this.el = tulpasynth.canvas.circle(this.instrument.get('startTime') * tulpasynth.canvas.width, tulpasynth.timeline.get_y_value(this.instrument.get('pitchIndex')), 10);
      return this;
    };

    return SquareToggleButton;

  })();

}).call(this);
