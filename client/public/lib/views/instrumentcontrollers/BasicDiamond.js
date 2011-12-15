(function() {

  /*
  #   @file       BasicDiamond.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  /*
  #   @class  Basic diamond shape.
  */

  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  tulpasynth.views.instrumentcontrollers.BasicDiamond = (function() {

    __extends(BasicDiamond, tulpasynth.views.instrumentcontrollers.InstrumentController);

    function BasicDiamond() {
      BasicDiamond.__super__.constructor.apply(this, arguments);
    }

    BasicDiamond.prototype.render = function() {
      var x, y;
      BasicDiamond.__super__.render.apply(this, arguments);
      if (!this.controller) {
        this.controller = tulpasynth.canvas.path();
        this.all.push(this.controller);
      }
      y = tulpasynth.timeline.get_y_value(this.instrument.get('pitchIndex')) + 10;
      x = this.instrument.get('startTime') * tulpasynth.canvas.width;
      this.controller.attr({
        fill: '90-#B80909-#FF2E2E:80-#FF2E2E',
        "stroke-width": 1,
        path: "M" + x + "," + y + " l 10,10 l -10,10 l -10,-10 l 10,-10 z "
      });
      return this;
    };

    return BasicDiamond;

  })();

}).call(this);
