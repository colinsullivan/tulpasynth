(function() {

  /*
  #   @file       ControllerChooserPopup.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  /*
  #   @class  Popup for user to select controller with.
  #
  #   Displays a popup containing demo versions of each controller
  #   type.  When a user selects one of the controllers, it will
  #   be placed in the location of the first click with its 
  #   corresponding instrument.
  */

  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  tulpasynth.views.ControllerChooserPopup = (function() {

    __extends(ControllerChooserPopup, Backbone.View);

    function ControllerChooserPopup() {
      ControllerChooserPopup.__super__.constructor.apply(this, arguments);
    }

    ControllerChooserPopup.prototype.initialize = function() {
      /*
              #   Set of all elements rendered for popup.
      */      this.set = null;
      /*
              #   If the popup is currently visible
      */
      this.active = false;
      /*
              #   Current coordinates of pointer arrow
      */
      this.currentArrowCoords = null;
      /*
              #   Current pitch index at pointer arrow
      */
      return this.currentPitchIndex = null;
    };

    /*
        #   Hide popup.
    */

    ControllerChooserPopup.prototype.hide = function() {
      this.set.remove();
      return this.active = false;
    };

    /*
        #   Show popup.
        #
        #   @param  arrowCoords     The coordinates of the popup point.
        #   @param  pitchIndex      Pitch index of popup point.
    */

    ControllerChooserPopup.prototype.show = function(arrowCoords, pitchIndex) {
      var bubble, bubblyExample, canvasHeight, canvasWidth, controllerStart, earthExample, instrumentType, orchestra, organBellExample, pathText, pen, pricklyExample, rectBottomSegmentWidth, rectHeight, rectWidth, rotateDegrees, snareExample;
      var _this = this;
      if (this.active) {
        this.hide();
        return;
      }
      this.currentArrowCoords = arrowCoords;
      this.currentPitchIndex = pitchIndex;
      this.set = tulpasynth.canvas.set();
      pen = {
        x: arrowCoords.x,
        y: arrowCoords.y
      };
      rotateDegrees = 0;
      canvasHeight = tulpasynth.canvas.height;
      canvasWidth = tulpasynth.canvas.width;
      if (pen.x < 100 && pen.y < 100) {
        rotateDegrees = 135;
      } else if (pen.x < 100 && canvasHeight - pen.y < 100) {
        rotateDegrees = 45;
      } else if (canvasWidth - pen.x < 100 && canvasHeight - pen.y < 100) {
        rotateDegrees = -45;
      } else if (canvasWidth - pen.x < 100 && pen.y < 100) {
        rotateDegrees = -135;
      } else if (pen.y < 100) {
        rotateDegrees = 180;
      } else if (pen.x < 100) {
        rotateDegrees = 90;
      }
      pen.x -= 50;
      pen.y -= 110;
      controllerStart = {
        x: pen.x,
        y: pen.y
      };
      orchestra = tulpasynth.orchestra;
      instrumentType = tulpasynth.models.instruments.Bubbly;
      if (orchestra.new_instrument_allowed(instrumentType)) {
        bubblyExample = tulpasynth.canvas.circle(pen.x, pen.y, 10);
        bubblyExample.attr({
          fill: '90-#00AB86-#02DEAE:80-#02DEAE',
          'stroke-width': 1
        });
        bubblyExample.click(function() {
          var coords;
          _this.hide();
          coords = _this.currentArrowCoords;
          return new tulpasynth.models.instruments.Bubbly({
            startTime: coords.x / tulpasynth.canvas.width,
            x: coords.x,
            y: coords.y,
            pitchIndex: _this.currentPitchIndex
          });
        });
        this.set.push(bubblyExample);
      }
      pen.x += 20;
      pen.y -= 10;
      instrumentType = tulpasynth.models.instruments.Earth;
      if (orchestra.new_instrument_allowed(instrumentType)) {
        earthExample = tulpasynth.canvas.rect(pen.x, pen.y, 20, 20);
        earthExample.attr({
          fill: '90-#0038BA-#1659F5:80-#1659F5',
          "stroke-width": 1
        });
        earthExample.click(function() {
          var coords;
          _this.hide();
          coords = _this.currentArrowCoords;
          return new tulpasynth.models.instruments.Earth({
            startTime: coords.x / tulpasynth.canvas.width,
            x: coords.x,
            y: coords.y,
            pitchIndex: _this.currentPitchIndex
          });
        });
        this.set.push(earthExample);
      }
      pen.x += 10;
      pen.y += 30;
      instrumentType = tulpasynth.models.instruments.DistortedSnare;
      if (orchestra.new_instrument_allowed(instrumentType)) {
        snareExample = tulpasynth.canvas.path('M' + pen.x + ',' + pen.y + ' l 10,10 l -10,10 l -10,-10 l 10,-10z');
        snareExample.attr({
          fill: 'red'
        });
        snareExample.click(function() {
          var coords, startTime;
          _this.hide();
          coords = _this.currentArrowCoords;
          startTime = coords.x / tulpasynth.canvas.width;
          return new tulpasynth.models.instruments.DistortedSnare({
            startTime: startTime,
            x: coords.x,
            y: coords.y,
            pitchIndex: _this.currentPitchIndex
          });
        });
        this.set.push(snareExample);
      }
      pen.x += 35;
      pen.y -= 20;
      instrumentType = tulpasynth.models.instruments.Prickly;
      if (orchestra.new_instrument_allowed(instrumentType)) {
        pricklyExample = tulpasynth.canvas.ellipse(pen.x, pen.y, 15, 10);
        pricklyExample.attr({
          fill: '90-#C47300-#FF9500:80-#FF9500',
          'stroke-width': 1
        });
        pricklyExample.click(function() {
          var coords, startTime;
          _this.hide();
          coords = _this.currentArrowCoords;
          startTime = coords.x / tulpasynth.canvas.width;
          return new tulpasynth.models.instruments.Prickly({
            startTime: startTime,
            endTime: startTime + 0.11,
            x: coords.x,
            y: coords.y,
            pitchIndex: _this.currentPitchIndex
          });
        });
        this.set.push(pricklyExample);
      }
      pen.y += 20;
      pen.x -= 15;
      instrumentType = tulpasynth.models.instruments.OrganBell;
      if (orchestra.new_instrument_allowed(instrumentType)) {
        organBellExample = tulpasynth.canvas.path();
        organBellExample.attr({
          path: "M" + pen.x + "," + pen.y + " s2.5,2.5,30,10 s-2.5,-2.5,-30,10 z",
          fill: '90-#0E8A00-#14C900',
          'stroke-width': 1
        });
        organBellExample.click(function() {
          var coords, startTime;
          _this.hide();
          coords = _this.currentArrowCoords;
          startTime = coords.x / tulpasynth.canvas.width;
          return new instrumentType({
            startTime: startTime,
            x: coords.x,
            y: coords.y,
            pitchIndex: _this.currentPitchIndex
          });
        });
        this.set.push(organBellExample);
      }
      /*
              #   Now draw box around sample controllers
      */
      rectWidth = 120;
      rectHeight = 100;
      rectBottomSegmentWidth = (rectWidth / 2) - 15;
      pathText = 'M';
      pathText += ' ' + arrowCoords.x + ' ' + arrowCoords.y;
      pathText += ' l 15 -15';
      pathText += ' ' + rectBottomSegmentWidth + ' 0';
      pathText += ' a -10,-10 30 0,0 10,-10 ';
      pathText += ' l 0 -' + rectHeight;
      pathText += ' a -10,-10 30 0,0 -10,-10';
      pathText += ' l -' + rectWidth + ' 0 ';
      pathText += ' a -10,-10 30 0,0 -10,10';
      pathText += ' l 0 ' + rectHeight;
      pathText += ' a -10,-10 30 0,0 10,10';
      pathText += ' l ' + rectBottomSegmentWidth + ' 0';
      pathText += ' z';
      bubble = tulpasynth.canvas.path(pathText);
      this.set.push(bubble);
      this.set.rotate(rotateDegrees, arrowCoords.x, arrowCoords.y);
      return this.active = true;
    };

    return ControllerChooserPopup;

  })();

}).call(this);
