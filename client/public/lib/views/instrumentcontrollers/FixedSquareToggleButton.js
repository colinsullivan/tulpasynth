(function() {

  /*
  #   @file       FixedSquareToggleButton.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  /*
  #   @class  Fixed square toggle button.
  */

  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  tulpasynth.views.instrumentcontrollers.FixedSquareToggleButton = (function() {

    __extends(FixedSquareToggleButton, Backbone.View);

    function FixedSquareToggleButton() {
      FixedSquareToggleButton.__super__.constructor.apply(this, arguments);
    }

    FixedSquareToggleButton.prototype.initialize = function(options) {
      var _this = this;
      options = options || {};
      this.instrument = options.instrument;
      this.el = $(this.el);
      this.el.attr({
        'class': 'instrument glitch disabled'
      });
      return this.instrument.bind('change', function() {
        return _this.render();
      });
    };

    FixedSquareToggleButton.prototype.events = {
      'click': 'toggle'
    };

    FixedSquareToggleButton.prototype.render = function() {
      var instrument, leftValue;
      instrument = this.instrument;
      leftValue = instrument.get('startTime') * 1024 - this.el.width() / 2;
      this.el.css({
        left: leftValue
      });
      if (instrument.get('disabled') === true) {
        this.el.addClass('disabled');
      } else {
        this.el.removeClass('disabled');
      }
      return this;
    };

    FixedSquareToggleButton.prototype.toggle = function() {
      this.instrument.set({
        disabled: !this.instrument.get('disabled')
      });
      return this.instrument.save();
    };

    return FixedSquareToggleButton;

  })();

}).call(this);
