(function() {

  /*
  #   @file       BasicOval.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  /*
  #   @class  Basic class for an oval that has the same width as
  #   the sound's duration.
  */

  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  tulpasynth.views.instrumentcontrollers.BasicOval = (function() {

    __extends(BasicOval, tulpasynth.views.instrumentcontrollers.InstrumentController);

    function BasicOval() {
      BasicOval.__super__.constructor.apply(this, arguments);
    }

    BasicOval.prototype.render = function() {
      var duration, endTime, startTime, width;
      BasicOval.__super__.render.apply(this, arguments);
      startTime = this.instrument.get('startTime');
      endTime = this.instrument.get('endTime');
      duration = endTime - startTime;
      width = duration * tulpasynth.canvas.width;
      this.controller = tulpasynth.canvas.ellipse(startTime * tulpasynth.canvas.width, tulpasynth.timeline.get_y_value(this.instrument.get('pitchIndex')), width / 2, 15);
      this.controller.attr({
        fill: 'green'
      });
      this.post_render();
      return this;
    };

    return BasicOval;

  })();

}).call(this);
