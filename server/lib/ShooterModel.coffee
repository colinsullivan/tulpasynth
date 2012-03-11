###
#   @file       ShooterModel.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2012 Colin Sullivan
#               Licensed under the MIT license.
###

tulpasynth = require "./tulpasynth.coffee"
Backbone = require "backbone"

###
#   @class  Model of a shooter object
###
class tulpasynth.models.ShooterModel extends Backbone.Model
    initialize: () ->
        if @get "rate"
            nextShotTime = new Date()
            @set "nextShotTime", (nextShotTime.getTime()/1000) + (1.0 / @get "rate")

            setTimeout () =>
                @updateNextShotTime()
            , (1.0/@get("rate"))*500.0

    updateNextShotTime: () ->
        console.log "updateNextShotTime"
        # Update next shot time to previous shot time plus rate
        @set "nextShotTime", @get("nextShotTime") + (1.0 / @get "rate")

        # Update again
        setTimeout () =>
            @updateNextShotTime()
        , (1.0 / @get("rate"))*1000.0

        tulpasynth.modelInstances[@get "id"] = this
