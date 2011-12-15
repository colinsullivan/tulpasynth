(function() {

  /*
  #   @file       OrganBell.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  /*
  #   @class  Organ bell instrument.
  */

  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  tulpasynth.models.instruments.OrganBell = (function() {

    __extends(OrganBell, tulpasynth.models.instruments.PitchedInstrument);

    function OrganBell() {
      OrganBell.__super__.constructor.apply(this, arguments);
    }

    OrganBell.prototype.namespace = 'tulpasynth.models.instruments.OrganBell';

    OrganBell.prototype.maxInstances = 8;

    OrganBell.prototype.initialize = function(attributes) {
      if (!this.get("gain")) {
        this.set({
          'gain': 0.10
        });
      }
      return OrganBell.__super__.initialize.apply(this, arguments);
    };

    return OrganBell;

  })();

}).call(this);
