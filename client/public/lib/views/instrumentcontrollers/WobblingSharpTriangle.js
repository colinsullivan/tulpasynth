(function() {

  /*
  #   @file       WobblingSharpTriangle.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  /*
  #   @class  Rectangle with adjustable edges.
  */

  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  tulpasynth.views.instrumentcontrollers.WobblingSharpTriangle = (function() {

    __extends(WobblingSharpTriangle, tulpasynth.views.instrumentcontrollers.InstrumentController);

    function WobblingSharpTriangle() {
      WobblingSharpTriangle.__super__.constructor.apply(this, arguments);
    }

    WobblingSharpTriangle.prototype.initialize = function() {
      /*
              #   Coordinates of top left corner
      */
      var _this = this;
      this.topLeft = {
        x: null,
        y: null
      };
      /*
              #   width
      */
      this.width = null;
      /*
              #   If we're currently performing wiggling animation
      */
      this.wiggling = false;
      this.wigglingDirecton = null;
      tulpasynth.orchestra.bind('change:t', function(orchestra) {
        var playheadX, t;
        t = orchestra.get('t');
        playheadX = t * tulpasynth.canvas.width;
        if ((_this.width != null) && !_this.wiggling && playheadX > _this.topLeft.x && playheadX < _this.topLeft.x + _this.width + 50) {
          return _this._start_wiggling();
        } else if ((_this.width != null) && _this.wiggling && (playheadX < _this.topLeft.x || playheadX > _this.topLeft.x + _this.width + 50)) {
          return _this._stop_wiggling();
        }
      });
      return WobblingSharpTriangle.__super__.initialize.apply(this, arguments);
    };

    WobblingSharpTriangle.prototype._start_wiggling = function() {
      this.wigglingDirection = -1;
      this._wiggle();
      return this.wiggling = true;
    };

    WobblingSharpTriangle.prototype._wiggle = function() {
      var attrs;
      var _this = this;
      this.wigglingDirection *= -1;
      attrs = {
        path: "M" + this.topLeft.x + "," + this.topLeft.y + " s5,5," + this.width + "," + (10 + this.wigglingDirection * 10) + " s-5,-5,-" + this.width + "," + (10 - this.wigglingDirection * 10) + " z"
      };
      return this.controller.animate(attrs, '30', 'linear', function() {
        if (_this.wiggling) {
          return _this._wiggle();
        } else {
          return _this.render();
        }
      });
    };

    WobblingSharpTriangle.prototype._stop_wiggling = function() {
      return this.wiggling = false;
    };

    WobblingSharpTriangle.prototype.render = function() {
      var attrs;
      WobblingSharpTriangle.__super__.render.apply(this, arguments);
      if (!this.controller) {
        this.controller = tulpasynth.canvas.path();
        this.all.push(this.controller);
      }
      this.topLeft.x = this.instrument.get('startTime') * tulpasynth.canvas.width;
      this.topLeft.y = tulpasynth.timeline.get_y_value(this.instrument.get('pitchIndex'));
      this.width = 150;
      attrs = {
        path: "M" + this.topLeft.x + "," + this.topLeft.y + " s5,5," + this.width + ",10 s-5,-5,-" + this.width + ",10 z",
        fill: '90-#0E8A00-#14C900:80-#14C900',
        'stroke-width': 1
      };
      return this.controller.attr(attrs);
    };

    return WobblingSharpTriangle;

  })();

}).call(this);
