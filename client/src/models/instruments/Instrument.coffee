###
#   @file       Instrument.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the GPLv3 license.
###

###
#   @class  Base class for all instruments.
###
class tulpasynth.models.instruments.Instrument extends Backbone.RelationalModel

    ###
    #   All instruments must include their namespace as a string
    ###
    namespace: 'tulpasynth.models.instruments.Instrument'

    ###
    #   When an instrument is created, it has no id.  We will ask for
    #   one from the server, then finish initializing when it comes.
    ###
    initialize: (attributes) ->
        @initialized = false

        # If this object was not initialized with an id
        if not attributes['id']            

            # Request an id
            tulpasynth.socket.send
                method: 'request/id'
            
            # Wait
            tulpasynth.models.waitingInstances.push this
        else
            @initialized = true
        
        if not @get "gain"
            @set
                gain: 1


        super
        
    ###
    #   When the instrument receives its id it will continue 
    #   initializing here.
    ###
    _complete_initialize: () ->
        tulpasynth.orchestra.get('instruments').add(this)
        @initialized = true

    ###
    #   If the id of this instrument is being set, add to the
    #   orchestra once finished.
    #
    #   Also check duration to ensure it doesn't go below 0.1, and
    #   that start/end times do not go out of bounds.
    ###
    set: (attrs, options) ->

        finishInitializing = false

        # If we're receiving an id
        if not @get('id') and attrs['id'] and not @initialized
            finishInitializing = true

        # If start/end times are being changed
        if attrs? and (attrs.startTime? or attrs.endTime?)            
            startTime = attrs.startTime || this.get 'startTime'
            endTime = attrs.endTime || this.get 'endTime'


            # If duration is going to be changed to too small of a value
            if endTime? and endTime - startTime < 0.09
                # Ignore changes to start/end times
                delete attrs.startTime
                delete attrs.endTime
            
            # If start or end times will be out of bounds
            if startTime < 0.0 || startTime > 1 || endTime < 0.0 || endTime > 1
                # Ignore changes to start/end times
                delete attrs.startTime
                delete attrs.endTime

        super
        
                
        # Finish initializing if necessary.
        if finishInitializing
            @_complete_initialize()
        

        return this
            

###
#   @class  A set of instrument instances.
###
class tulpasynth.models.instruments.InstrumentCollection extends Backbone.Collection
    model: tulpasynth.models.instruments.Instrument