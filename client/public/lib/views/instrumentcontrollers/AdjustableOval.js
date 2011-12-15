(function() {

  /*
  #   @file       AdjustableOval.coffee
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

  tulpasynth.views.instrumentcontrollers.AdjustableOval = (function() {

    __extends(AdjustableOval, tulpasynth.views.instrumentcontrollers.InstrumentController);

    function AdjustableOval() {
      AdjustableOval.__super__.constructor.apply(this, arguments);
    }

    AdjustableOval.prototype.initialize = function(options) {
      /*
              #   Resize handles on left and right of oval.
      */      this.leftHandle = null;
      this.rightHandle = null;
      /*
              #   If we're currently dragging the handles
      */
      this.dragging = false;
      /*
              #   Hide handles after an amount of time
      */
      this.handleHideTimeout = null;
      return AdjustableOval.__super__.initialize.call(this, options);
    };

    AdjustableOval.prototype.render = function() {
      var controllerAttrs, duration, endTime, handleAttrs, leftHandleAttrs, ovalWidth, rightHandleAttrs, startTime, y;
      AdjustableOval.__super__.render.apply(this, arguments);
      startTime = this.instrument.get('startTime');
      endTime = this.instrument.get('endTime');
      duration = endTime - startTime;
      ovalWidth = duration * tulpasynth.canvas.width;
      y = tulpasynth.timeline.get_y_value(this.instrument.get('pitchIndex'));
      controllerAttrs = {
        fill: '90-#C47300-#FF9500:80-#FF9500',
        'stroke-width': 1,
        cx: startTime * tulpasynth.canvas.width + ovalWidth / 2,
        cy: y,
        rx: ovalWidth / 2,
        ry: 15
      };
      if (!this.controller) {
        this.controller = tulpasynth.canvas.ellipse();
        this.all.push(this.controller);
      }
      this.controller.attr(controllerAttrs);
      handleAttrs = {
        fill: 'white',
        'stroke-width': 2,
        r: 5,
        cy: y,
        'cursor': 'ew-resize'
      };
      leftHandleAttrs = _.extend({
        cx: startTime * tulpasynth.canvas.width + 1
      }, handleAttrs);
      rightHandleAttrs = _.extend({
        cx: endTime * tulpasynth.canvas.width - 1
      }, handleAttrs);
      if (!this.leftHandle) {
        this.leftHandle = tulpasynth.canvas.circle();
        this.all.push(this.leftHandle);
      }
      this.leftHandle.attr(leftHandleAttrs);
      if (!this.rightHandle) {
        this.rightHandle = tulpasynth.canvas.circle();
        this.all.push(this.rightHandle);
      }
      this.rightHandle.attr(rightHandleAttrs);
      this.leftHandle.toFront();
      this.rightHandle.toFront();
      if (!this.dragging) this._hide_handles();
      return this;
    };

    /*
        #   Reveal the resize handles on left and right side of oval.
    */

    AdjustableOval.prototype._show_handles = function() {
      var handleAttrs;
      var _this = this;
      handleAttrs = {
        r: 5
      };
      this.leftHandle.animate(handleAttrs, 250, 'bounce');
      this.rightHandle.animate(handleAttrs, 250, 'bounce');
      if (this.handleHideTimeout) clearTimeout(this.handleHideTimeout);
      return this.handleHideTimeout = setTimeout(function() {
        return _this._hide_handles();
      }, 1000);
    };

    /*
        #   Hide the resize handles.
    */

    AdjustableOval.prototype._hide_handles = function(e) {
      var handleAttrs;
      if ((e != null) && (e.toElement != null) && (e.toElement === this.leftHandle.node || e.toElement === this.rightHandle.node || e.toElement === this.controller.node)) {
        return;
      }
      handleAttrs = {
        r: 0
      };
      this.leftHandle.attr(handleAttrs);
      return this.rightHandle.attr(handleAttrs);
    };

    AdjustableOval.prototype.post_render = function() {
      var dragEnd, dragStart;
      var _this = this;
      AdjustableOval.__super__.post_render.apply(this, arguments);
      this.controller.hover(function(e) {
        return _this._show_handles(e);
      }, function(e) {
        return _this._hide_handles(e);
      });
      this.rightHandle.hover(function(e) {
        return _this._show_handles(e);
      }, function(e) {
        return _this._hide_handles(e);
      });
      this.leftHandle.hover(function(e) {
        return _this._show_handles(e);
      }, function(e) {
        return _this._hide_handles(e);
      });
      dragStart = function() {
        _this.dragging = true;
        return document.body.style.cursor = "ew-resize";
      };
      dragEnd = function() {
        _this.dragging = false;
        _this.instrument.save();
        return document.body.style.cursor = "auto";
      };
      this.leftHandle.drag(function(dx, dy, x, y) {
        return _this.instrument.set({
          startTime: x / tulpasynth.canvas.width
        });
      }, dragStart, dragEnd);
      return this.rightHandle.drag(function(dx, dy, x, y) {
        return _this.instrument.set({
          endTime: x / tulpasynth.canvas.width
        });
      }, dragStart, dragEnd);
    };

    return AdjustableOval;

  })();

}).call(this);
