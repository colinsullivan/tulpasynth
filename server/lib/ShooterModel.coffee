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
class tulpasynth.models.ShooterModel extends tulpasynth.models.TulpasynthModel
    initialize: () ->
        @nextUpdateTimeout = null;
        # if @get "rate"
            # @updateNextShotTimes()
            # nextShotTime = new Date()
            # @set "nextShotTime", (nextShotTime.getTime()/1000) + (1.0 / @get "rate")

            # setTimeout () =>
            #     @updateNextShotTime()
            # , (1.0/@get("rate"))*1000.0

        super()


    updateNextShotTimes: () ->
        if @get "destroyed"
            return;

        shotTimes = @get("shotTimes")
        latestShotTime = shotTimes[shotTimes.length-1]

        # Calculate the next 1 seconds worth of shots
        last = shotTimes[shotTimes.length-1]
        while last < latestShotTime+1.0
            shotTimes.push(last + (1.0/@get("rate")))
            last = shotTimes[shotTimes.length-1]

        # currentShotIndex = @get("nextShotIndex")*1
        # now = ((new Date()).getTime()/1000)
        # while now > shotTimes[currentShotIndex]
        #     currentShotIndex++

        # @set "nextShotIndex", currentShotIndex
        
        @set "shotTimes", shotTimes
        # TODO: this should be triggered automatically but it is not
        @trigger "change:shotTimes"

        @nextUpdateTimeout = setTimeout () =>
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

###
#   @class  
###
class tulpasynth.models.ReceivingShooterModel extends tulpasynth.models.ShooterModel
    
