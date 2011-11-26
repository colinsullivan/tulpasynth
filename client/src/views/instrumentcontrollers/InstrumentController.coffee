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
        

        # When instrument's data is changed, re-render        
        @instrument.bind 'change', () => 
            @render()
    
    render: () ->

        return @
