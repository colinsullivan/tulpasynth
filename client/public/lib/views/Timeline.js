(function() {

  /*
  #   @file       Timeline.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  /*
  #   @class  Master view, Timeline and all Instrument rendering.
  */

  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  tulpasynth.views.Timeline = (function() {

    __extends(Timeline, Backbone.View);

    function Timeline() {
      Timeline.__super__.constructor.apply(this, arguments);
    }

    Timeline.prototype.initialize = function() {
      /*
              #   Our entire timeline canvas.
      */
      var gridLine, i, orchestra, xGridSize, yGridSize, _i, _len, _ref;
      var _this = this;
      this.el = $('#canvas');
      /*
              #   Timeline background
      */
      this.background = tulpasynth.canvas.rect(0, 0, '100%', '100%');
      this.background.attr({
        fill: 'transparent',
        "stroke-width": 0
      });
      /*
              #   Height and width of our canvas (hardcoded for now)
      */
      this.height = 768;
      this.width = 1024;
      /*
              #   Grid for placing objects on y-axis
      */
      this.yGrid = [];
      yGridSize = 32;
      this.yPxPerGrid = this.height / yGridSize;
      for (i = 0; 0 <= yGridSize ? i < yGridSize : i > yGridSize; 0 <= yGridSize ? i++ : i--) {
        this.yGrid.push(i * this.yPxPerGrid);
      }
      /*
              #   Grid for x-axis (just for drawing currently)
      */
      this.xGrid = [];
      xGridSize = this.width / 32;
      this.xPxPerGrid = this.width / xGridSize;
      for (i = 0; 0 <= xGridSize ? i < xGridSize : i > xGridSize; 0 <= xGridSize ? i++ : i--) {
        this.xGrid.push(i * this.xPxPerGrid);
      }
      this.xGridLines = [];
      _ref = this.xGrid;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        i = _ref[_i];
        gridLine = tulpasynth.canvas.path('M' + i + ',0 L' + i + ',' + this.height + ' z');
        gridLine.attr({
          'stroke-width': 1,
          'opacity': 0.25
        });
        gridLine.node.style["shapeRendering"] = 'crispEdges';
        this.xGridLines.push(gridLine);
      }
      /*
              #   Container for our instrument controllers
      */
      this.instrumentControllerContainer = $('#instruments');
      /*
              #   Playhead is a line on the canvas
      */
      this.playhead = tulpasynth.canvas.path();
      this.playhead.attr({
        'stroke-width': 1
      });
      this.playhead.node.style["shapeRendering"] = "crispEdges";
      /*
              #   Instrument controllers (by `Instrument.id`)
      */
      this.instrumentControllers = {};
      /*
              #   The chooser popup for when a user is selecting a 
              #   controller.
      */
      this.chooserPopup = new tulpasynth.views.ControllerChooserPopup();
      this.controllerDeleteArea = new tulpasynth.views.ControllerDeleteArea();
      orchestra = tulpasynth.orchestra;
      orchestra.bind('change:t', function(orchestra) {
        return _this.update_playhead(orchestra);
      });
      orchestra.bind('add:instruments', function(instrument) {
        return _this.create_instrument_controller(instrument);
      });
      orchestra.bind('remove:instruments', function(instrument) {
        var controller;
        controller = _this.instrumentControllers[instrument.get('id')];
        controller.all.undrag();
        controller.all.unhover();
        controller.all.remove();
        delete controller;
        return _this.instrumentControllers[instrument.get('id')] = null;
      });
      this.background.toFront();
      return this.background.click(function(e) {
        return _this._handle_click(e);
      });
    };

    Timeline.prototype.snap_y_value = function(y) {
      return Raphael.snapTo(this.yGrid, y, this.yPxPerGrid / 2);
    };

    Timeline.prototype.get_pitch_index = function(snappedY) {
      return _.indexOf(this.yGrid, snappedY, true);
    };

    Timeline.prototype.get_y_value = function(pitchIndex) {
      return pitchIndex * this.yPxPerGrid;
    };

    Timeline.prototype._handle_click = function(e) {
      var pitchIndex, y;
      y = this.snap_y_value(e.layerY);
      pitchIndex = this.get_pitch_index(y);
      if (pitchIndex === -1) return;
      return this.chooserPopup.show({
        x: e.layerX,
        y: y
      }, pitchIndex);
    };

    /*
        #   When the orchestra's time is changed, move playhead
        #   to the appropriate position.
    */

    Timeline.prototype.update_playhead = function(orchestra) {
      var x;
      x = orchestra.get('t') * this.width;
      return this.playhead.attr({
        path: 'M' + x + ',0 L' + x + ',' + this.height
      });
    };

    Timeline.prototype.create_instrument_controller = function(instrument) {
      var instrumentClassName, instrumentController, instrumentControllerClass, instrumentControllerClassMap, instrumentControllerClasses;
      instrumentClassName = instrument.namespace.replace("tulpasynth.models.instruments.", "");
      instrumentControllerClasses = tulpasynth.views.instrumentcontrollers;
      instrumentControllerClassMap = {
        "Bubbly": 'BasicCircle',
        "Earth": 'BasicSquare',
        'Prickly': 'AdjustableOval',
        'DistortedSnare': 'BasicDiamond',
        'OrganBell': 'WobblingSharpTriangle'
      };
      instrumentControllerClass = instrumentControllerClasses[instrumentControllerClassMap[instrumentClassName]];
      if (!(instrumentControllerClass != null)) {
        throw new Error("Instrument controller class not found for `" + instrumentClassName + "`");
      }
      instrumentController = new instrumentControllerClass({
        instrument: instrument
      });
      return this.instrumentControllers[instrument.get('id')] = instrumentController;
    };

    return Timeline;

  })();

}).call(this);
