(function() {

  /*
  #   @file       HarmonicTable.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  /*
  #   @class  Abstraction around harmonic table pitches.
  #
  #   TODO: Top left pitch
  #   Width
  #   Height
  */

  var HarmonicTable;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  HarmonicTable = (function() {

    __extends(HarmonicTable, tulpasynth.models.instruments.Instrument);

    function HarmonicTable() {
      HarmonicTable.__super__.constructor.apply(this, arguments);
    }

    HarmonicTable.prototype.initialize = function(attributes) {
      attributes = attributes || {};
      if (!attributes.firstPitch) throw new Error("firstPitch required.");
      if (!attributes.width) throw new Error("width required.");
      if (!attributes.height) throw new Error("height required");
      return this.generate_table();
    };

    HarmonicTable.prototype.generate_table = function() {
      var x, _ref;
      this.table = [];
      for (x = 0, _ref = this.get('width'); 0 <= _ref ? x <= _ref : x >= _ref; 0 <= _ref ? x++ : x--) {
        return;
      }
    };

    return HarmonicTable;

  })();

}).call(this);
