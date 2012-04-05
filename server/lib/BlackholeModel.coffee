###
#   @file       BlackholeModel.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2012 Colin Sullivan
#               Licensed under the GPLv3 license.
###

tulpasynth = require "./tulpasynth.coffee"
Backbone = require "backbone"


###
#   @class  Server-side representation of a blackhole created by a user
###
class tulpasynth.models.BlackholeModel extends tulpasynth.models.TulpasynthModel
    initialize: () ->
        @relatedShooter = null

        super()

    eatenBallTimeDelay: 3.0