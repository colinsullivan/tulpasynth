(function() {

  /*
  #   @file       Instrument.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  /*
  #   @class  Base class for all instruments.
  */

  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  tulpasynth.models.instruments.Instrument = (function() {

    __extends(Instrument, Backbone.RelationalModel);

    function Instrument() {
      Instrument.__super__.constructor.apply(this, arguments);
    }

    /*
        #   All instruments must include their namespace as a string
    */

    Instrument.prototype.namespace = 'tulpasynth.models.instruments.Instrument';

    /*
        #   When an instrument is created, it has no id.  We will ask for
        #   one from the server, then finish initializing when it comes.
    */

    Instrument.prototype.initialize = function(attributes) {
      this.initialized = false;
      if (!attributes['id']) {
        tulpasynth.socket.send({
          method: 'request/id'
        });
        tulpasynth.models.waitingInstances.push(this);
      } else {
        this.initialized = true;
      }
      if (!this.get("gain")) {
        this.set({
          gain: 1
        });
      }
      return Instrument.__super__.initialize.apply(this, arguments);
    };

    /*
        #   When the instrument receives its id it will continue 
        #   initializing here.
    */

    Instrument.prototype._complete_initialize = function() {
      tulpasynth.orchestra.get('instruments').add(this);
      return this.initialized = true;
    };

    /*
        #   If the id of this instrument is being set, add to the
        #   orchestra once finished.
        #
        #   Also check duration to ensure it doesn't go below 0.1, and
        #   that start/end times do not go out of bounds.
    */

    Instrument.prototype.set = function(attrs, options) {
      var endTime, finishInitializing, startTime;
      finishInitializing = false;
      if (!this.get('id') && attrs['id'] && !this.initialized) {
        finishInitializing = true;
      }
      if ((attrs != null) && ((attrs.startTime != null) || (attrs.endTime != null))) {
        startTime = attrs.startTime || this.get('startTime');
        endTime = attrs.endTime || this.get('endTime');
        if ((endTime != null) && endTime - startTime < 0.09) {
          delete attrs.startTime;
          delete attrs.endTime;
        }
        if (startTime < 0.0 || startTime > 1 || endTime < 0.0 || endTime > 1) {
          delete attrs.startTime;
          delete attrs.endTime;
        }
      }
      Instrument.__super__.set.apply(this, arguments);
      if (finishInitializing) this._complete_initialize();
      return this;
    };

    return Instrument;

  })();

  /*
  #   @class  A set of instrument instances.
  */

  tulpasynth.models.instruments.InstrumentCollection = (function() {

    __extends(InstrumentCollection, Backbone.Collection);

    function InstrumentCollection() {
      InstrumentCollection.__super__.constructor.apply(this, arguments);
    }

    InstrumentCollection.prototype.model = tulpasynth.models.instruments.Instrument;

    return InstrumentCollection;

  })();

}).call(this);
