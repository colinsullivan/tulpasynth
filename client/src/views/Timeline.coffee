###
#   @file       Timeline.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the MIT license.
###


###
#   @class  Master view, Timeline and all Instrument rendering.
###
class hwfinal.views.Timeline extends Backbone.View
    initialize: () ->
        ###
        #   Our entire timeline canvas.
        ###
        @el = $ '#canvas'

        ###
        #   Container for our instrument controllers
        ###
        @instrumentControllerContainer = $ '#instruments'

        ###
        #   Playhead element (only one)
        ###
        @playheadElement = $ '#playhead'

        ###
        #   Instrument controllers (by `Instrument.id`)
        ###
        @instrumentControllers = {}

        orchestra = hwfinal.orchestra

        # If orchestra's time is updated
        orchestra.bind 'change:t', (orchestra) =>
            # Render accordingly
            @update_playhead orchestra
        
        # If an instrument is added to the orchestra
        orchestra.bind 'add:instruments', (instrument) =>
            @create_instrument_controller instrument

    
    ###
    #   When the orchestra's time is changed, move playhead
    #   to the appropriate position.
    ###
    update_playhead: (orchestra) ->
        @playheadElement.css
            'left': orchestra.get('t')*100+"%"
    
    create_instrument_controller: (instrument) ->
        instrumentClassName = instrument.namespace.replace "hwfinal.models.instruments.Instrument.", ""

        instrumentControllerClass = null

        instrumentControllerClasses = hwfinal.views.instrumentcontrollers


        instrumentControllerClassMap = 
            "Glitch": instrumentControllerClasses['FixedSquareToggleButton']

        
        instrumentController = new instrumentControllerClassMap[instrumentClassName]
            instrument: instrument
        
        # Add controller into datastructure
        @instrumentControllers[instrument.get('id')] = instrumentController

        # Add controller onto timeline
        @instrumentControllerContainer.append instrumentController.el

        # Render
        instrumentController.render()

