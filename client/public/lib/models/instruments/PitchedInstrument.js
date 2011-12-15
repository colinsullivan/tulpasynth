(function() {

  /*
  #   @file       PitchedInstrument.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  /*
  #   @class  Base class for all instruments that have a pitch.
  */

  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  tulpasynth.models.instruments.PitchedInstrument = (function() {

    __extends(PitchedInstrument, tulpasynth.models.instruments.Instrument);

    function PitchedInstrument() {
      PitchedInstrument.__super__.constructor.apply(this, arguments);
    }

    PitchedInstrument.prototype.initialize = function(attributes) {
      /*
              #   The minimum pitch index allowed for this instrument.
      */      if (!(this.minPitchIndex != null)) this.minPitchIndex = 0;
      /*
              #   The maximum pitch index allowed for this instrument.
      */
      if (!this.maxPitchIndex) this.maxPitchIndex = 32;
      return PitchedInstrument.__super__.initialize.apply(this, arguments);
    };

    /*
        #   If pitchIndex is being changed, make sure it is
        #   within bounds.
    */

    PitchedInstrument.prototype.set = function(attrs, options) {
      return PitchedInstrument.__super__.set.apply(this, arguments);
    };

    return PitchedInstrument;

  })();

}).call(this);
