###
#   @file       Instrument.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the MIT license.
###

###
#   @class  Base class for all instruments.
###
class hwfinal.models.instruments.Instrument extends Backbone.RelationalModel

    ###
    #   All instruments must include their namespace as a string
    ###
    namespace: 'hwfinal.models.instruments.Instrument'

    ###
    #   When an instrument is created, it has no id.  We will ask for
    #   one from the server, then finish initializing when it comes.
    ###
    initialize: (attributes) ->
        @initialized = false

        # If this object was not initialized with an id
        if not attributes['id']            

            # Request an id
            hwfinal.socket.send
                method: 'request/id'
            
            # Wait
            hwfinal.models.waitingInstances.push this
        else
            @initialized = true

        super
    
    ###
    #   When the instrument receives its id it will continue 
    #   initializing here.
    ###
    _complete_initialize: () ->
        hwfinal.orchestra.get('instruments').add(this)
        @initialized = true

    ###
    #   If the id of this instrument is being set, add to the
    #   orchestra once finished.
    ###
    set: (attrs, options) ->

        finishInitializing = false

        # If we're receiving an id
        if not @get('id') and attrs['id'] and not @initialized
            finishInitializing = true
            

        super
        
                
        # Finish initializing if necessary.
        if finishInitializing
            @_complete_initialize()
        

        return this
            

###
#   @class  A set of instrument instances.
###
class hwfinal.models.instruments.InstrumentCollection extends Backbone.Collection
    model: hwfinal.models.instruments.Instrument