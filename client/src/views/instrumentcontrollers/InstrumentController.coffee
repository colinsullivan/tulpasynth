###
#   @file       InstrumentController.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the MIT license.
###

###
#   @class  Base instrument controller class.
###
class hwfinal.views.instrumentcontrollers.InstrumentController extends Backbone.View
    initialize: (options) ->
        options = options || {}

        @instrument = options.instrument

        ###
        #   controller will be the reference to the RaphaelJS object.
        ###
        @controller = null
        

        # When instrument's data is changed, re-render        
        @instrument.bind 'change', () => 
            @render()
        
        # When instrument is deleted, delete controller
        # @instrument.bind 'destroy', () =>
        #     console.log '@controller'
        #     console.log @controller
            
        #     @controller.hide()
        #     # delete @
        
        @render()
        @post_render()
    
    render: () ->
        if @controller
            @controller.remove()
            @controller = null

        return @
    
    post_render: () ->

        @controller.click () =>
            console.log "Deleting instrument #{@instrument.get('id')}"
            @instrument.destroy()

