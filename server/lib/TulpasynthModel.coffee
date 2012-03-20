###
#   @file       TulpasynthModel.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2012 Colin Sullivan
#               Licensed under the MIT license.
###

tulpasynth = require "./tulpasynth.coffee"
Backbone = require "backbone"


###
#   @class  Base model class
###
class tulpasynth.models.TulpasynthModel extends Backbone.Model

    initialize: () ->
        tulpasynth.modelInstances[@get "id"] = this