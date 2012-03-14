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
        # if @get "rate"
            # @updateNextShotTimes()
            # nextShotTime = new Date()
            # @set "nextShotTime", (nextShotTime.getTime()/1000) + (1.0 / @get "rate")

            # setTimeout () =>
            #     @updateNextShotTime()
            # , (1.0/@get("rate"))*1000.0

        tulpasynth.modelInstances[@get "id"] = this

    updateNextShotTimes: () ->
        shotTimes = @get("shotTimes")
        latestShotTime = shotTimes[shotTimes.length-1]

        # Calculate the next 1 seconds worth of shots
        last = shotTimes[shotTimes.length-1]
        while last < latestShotTime+1.0
            shotTimes.push(last + (1.0/@get("rate")))
            last = shotTimes[shotTimes.length-1]
        
        @set "shotTimes", shotTimes
        # TODO: this should be triggered automatically but it is not
        @trigger "change:shotTimes"

        setTimeout () =>
            @updateNextShotTimes()
        , 1000.0


    # updateNextShotTime: () ->
    #     console.log "updateNextShotTime"

    #     now = new Date()
    #     now = now.getTime()/1000.0
        
    #     # if next shot has passed
    #     console.log '@get "nextShotTime"'
    #     console.log @get "nextShotTime"
    #     console.log 'now'
    #     console.log now
        
    #     if @get("nextShotTime")*1.0 < now
    #         # Update next shot time to previous shot time plus rate
    #         @set "nextShotTime", @get("nextShotTime") + (1.0 / @get "rate")


    #     # Update again in the future
    #     setTimeout () =>
    #         @updateNextShotTime()
    #     , (1.0 / @get("rate"))*1000.0
