(function() {

  /*
  #   @file       InstrumentController.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  /*
  #   @class  Base instrument controller class.
  */

  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  tulpasynth.views.instrumentcontrollers.InstrumentController = (function() {

    __extends(InstrumentController, Backbone.View);

    function InstrumentController() {
      InstrumentController.__super__.constructor.apply(this, arguments);
    }

    InstrumentController.prototype.initialize = function(options) {
      var _this = this;
      options = options || {};
      this.instrument = options.instrument;
      /*
              #   controller will be the reference to the RaphaelJS object.
      */
      this.controller = null;
      /*
              #   If a part of this controller is currently being dragged.
      */
      this.dragging = false;
      /*
              #   We'll save instrument after user stops dragging for
              #   a duration.
      */
      this.draggingSaveTimeout = null;
      /*
              #   If the controller is currently being clicked 
              #   (mouse button is held down).
      */
      this.mousedown = false;
      /*
              #   We will clear instrument after user has been holding mouse
              #   for a duration.  Here is where we'll store the reference to
              #   the timeout.
      */
      this.mousedownTimeout = null;
      /*
              #   Keep track of mouse position relative to BBox of controller.
      */
      this.controllerMousedownPosition = {
        x: null,
        y: null
      };
      this.draggingOverRecycleArea = false;
      /*
              #   All objects relating to this controller must reside in this set
      */
      this.all = tulpasynth.canvas.set();
      this.instrument.bind('change', function() {
        return _this.render();
      });
      this.render();
      return this.post_render();
    };

    InstrumentController.prototype.render = function() {
      return this;
    };

    InstrumentController.prototype._handle_controller_drag_start = function(x, y) {
      var bbox;
      console.log('_handle_controller_drag_start');
      tulpasynth.timeline.controllerDeleteArea.show();
      this.dragging = true;
      bbox = this.controller.getBBox();
      this.controllerMousedownPosition.x = x - bbox.x;
      return clearTimeout(this.draggingSaveTimeout);
    };

    InstrumentController.prototype._handle_controller_drag_end = function(e) {
      var _this = this;
      console.log("_handle_controller_drag_end");
      tulpasynth.timeline.controllerDeleteArea.hide();
      this.dragging = false;
      if (this._in_recycle_area(e.x, e.y)) {
        return this.instrument.destroy();
      } else {
        clearTimeout(this.draggingSaveTimeout);
        return this.draggingSaveTimeout = setTimeout(function() {
          if (!_this.dragging) return _this.instrument.save();
        }, 500);
      }
    };

    InstrumentController.prototype._in_recycle_area = function(x, y) {
      var controllerDeleteArea, controllerDeleteAreaBBox;
      controllerDeleteArea = tulpasynth.timeline.controllerDeleteArea;
      controllerDeleteAreaBBox = controllerDeleteArea.shownBBox;
      if (x > controllerDeleteAreaBBox.x && x < controllerDeleteAreaBBox.x + controllerDeleteAreaBBox.width && y > controllerDeleteAreaBBox.y && y < controllerDeleteAreaBBox.y + controllerDeleteAreaBBox.height) {
        return true;
      } else {
        return false;
      }
    };

    InstrumentController.prototype._handle_controller_drag = function(dx, dy, x, y) {
      var attrs, duration, newStartTime, pitchIndex, snappedY;
      if (this._in_recycle_area(x, y)) {
        tulpasynth.timeline.controllerDeleteArea.handle_drag_over();
        this.draggingOverRecycleArea = true;
      } else if (this.draggingOverRecycleArea) {
        this.draggingOverRecycleArea = false;
        tulpasynth.timeline.controllerDeleteArea.handle_drag_over_out();
      }
      x = x - this.controllerMousedownPosition.x;
      snappedY = tulpasynth.timeline.snap_y_value(y);
      pitchIndex = tulpasynth.timeline.get_pitch_index(snappedY);
      if (pitchIndex === -1) return;
      newStartTime = x / tulpasynth.canvas.width;
      attrs = {
        startTime: newStartTime,
        y: snappedY,
        pitchIndex: pitchIndex
      };
      if (this.instrument.get('endTime')) {
        duration = this.instrument.get('endTime') - this.instrument.get('startTime');
        attrs.endTime = newStartTime + duration;
      }
      return this.instrument.set(attrs);
    };

    InstrumentController.prototype.post_render = function() {
      var _this = this;
      return this.controller.drag(function(dx, dy, x, y) {
        return _this._handle_controller_drag(dx, dy, x, y);
      }, function(x, y) {
        return _this._handle_controller_drag_start(x, y);
      }, function(e) {
        return _this._handle_controller_drag_end(e);
      });
    };

    return InstrumentController;

  })();

}).call(this);
