(function() {

  /*
  #   @file       BasicCircle.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  /*
  #   @class  A basic black circle
  */

  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  tulpasynth.views.instrumentcontrollers.BasicCircle = (function() {

    __extends(BasicCircle, tulpasynth.views.instrumentcontrollers.InstrumentController);

    function BasicCircle() {
      BasicCircle.__super__.constructor.apply(this, arguments);
    }

    BasicCircle.prototype.render = function() {
      BasicCircle.__super__.render.apply(this, arguments);
      if (!this.controller) {
        this.controller = tulpasynth.canvas.circle();
        this.all.push(this.controller);
      }
      this.controller.attr({
        fill: '90-#00AB86-#02DEAE:80-#02DEAE',
        'stroke-width': 1,
        cx: this.instrument.get('startTime') * tulpasynth.canvas.width,
        cy: tulpasynth.timeline.get_y_value(this.instrument.get('pitchIndex')),
        r: 10
      });
      return this;
    };

    return BasicCircle;

  })();

}).call(this);
