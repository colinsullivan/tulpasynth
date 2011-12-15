(function() {

  /*
  #   @file       Orchestra.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  /*
  #   @class  The entire "loop" of audio.
  #
  #   The Orchestra (singleton) contains all of the
  #   current instrument instances, as well as the
  #   data relating to the synchronization of the 
  #   playhead in the loop.
  */

  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  tulpasynth.models.Orchestra = (function() {

    __extends(Orchestra, Backbone.RelationalModel);

    function Orchestra() {
      Orchestra.__super__.constructor.apply(this, arguments);
    }

    Orchestra.prototype.relations = [
      {
        type: Backbone.HasMany,
        key: 'instruments',
        relatedModel: 'tulpasynth.models.instruments.Instrument',
        collectionType: 'tulpasynth.models.instruments.InstrumentCollection',
        reverseRelation: {
          key: 'orchestra',
          includeInJSON: false
        }
      }
    ];

    Orchestra.prototype.initialize = function() {
      /*
              #   Keep track of the amount of instances of each.
      */
      var _this = this;
      this.numInstruments = {};
      this.bind('add:instruments', function(instrument) {
        _this.numInstruments[instrument.namespace] = _this.numInstruments[instrument.namespace] || 0;
        return _this.numInstruments[instrument.namespace]++;
      });
      return this.bind('remove:instruments', function(instrument) {
        return _this.numInstruments[instrument.namespace]--;
      });
    };

    /*
        #   Wether or not the creation of a new instrument of the given 
        #   type is allowed.
    */

    Orchestra.prototype.new_instrument_allowed = function(instrumentType) {
      var maxAllowed, namespace;
      namespace = instrumentType.prototype.namespace;
      maxAllowed = instrumentType.prototype.maxInstances;
      this.numInstruments[namespace] = this.numInstruments[namespace] || 0;
      return this.numInstruments[namespace] < maxAllowed;
    };

    return Orchestra;

  })();

}).call(this);
