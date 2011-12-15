(function() {

  /*
  #   @file       BasicSquare.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  /*
  #   @class  Basic black square.
  */

  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  tulpasynth.views.instrumentcontrollers.BasicSquare = (function() {

    __extends(BasicSquare, tulpasynth.views.instrumentcontrollers.InstrumentController);

    function BasicSquare() {
      BasicSquare.__super__.constructor.apply(this, arguments);
    }

    BasicSquare.prototype.render = function() {
      BasicSquare.__super__.render.apply(this, arguments);
      if (!this.controller) {
        this.controller = tulpasynth.canvas.rect();
        this.all.push(this.controller);
      }
      this.controller.attr({
        fill: '90-#0038BA-#1659F5:80-#1659F5',
        "stroke-width": 1,
        x: this.instrument.get('startTime') * tulpasynth.canvas.width,
        y: tulpasynth.timeline.get_y_value(this.instrument.get('pitchIndex')),
        width: 20,
        height: 20
      });
      return this;
    };

    return BasicSquare;

  })();

}).call(this);
