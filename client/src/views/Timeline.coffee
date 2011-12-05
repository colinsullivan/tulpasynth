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
        #   Timeline background
        ###
        @background = hwfinal.canvas.rect 0, 0, '100%', '100%'
        
        @background.attr
            fill: 'white'

        ###
        #   Height and width of our canvas (hardcoded for now)
        ###
        @height = 768;
        @width = 1024;

        ###
        #   Grid for placing objects on y-axis
        ###
        @yGrid = [];

        # We will have 32 spots in the grid for now
        yGridSize = 32
        @yPxPerGrid = @height/yGridSize

        for i in [0...yGridSize]
            @yGrid.push(i*@yPxPerGrid)
        

        ###
        #   Container for our instrument controllers
        ###
        @instrumentControllerContainer = $ '#instruments'

        ###
        #   Playhead is a line on the canvas
        ###
        @playhead = hwfinal.canvas.rect 0, 0, 1, "100%"

        ###
        #   Instrument controllers (by `Instrument.id`)
        ###
        @instrumentControllers = {}

        ###
        #   The chooser popup for when a user is selecting a 
        #   controller.
        ###
        @chooserPopup = new hwfinal.views.ControllerChooserPopup()

        orchestra = hwfinal.orchestra

        # If orchestra's time is updated
        orchestra.bind 'change:t', (orchestra) =>
            # Render accordingly
            @update_playhead orchestra
        
        # If an instrument is added to the orchestra
        orchestra.bind 'add:instruments', (instrument) =>
            @create_instrument_controller instrument
        
        # If an instrument is deleted, delete controller
        orchestra.bind 'remove:instruments', (instrument) =>
            controller = @instrumentControllers[instrument.get('id')]

            controller.controller.remove()
            delete controller
            @instrumentControllers[instrument.get('id')] = null
        
        @background.click (e) =>
            @_handle_click e
        
    _handle_click: (e) ->
        # Snap y value to grid
        y = Raphael.snapTo(@yGrid, e.layerY, @yPxPerGrid/2);

        # Get relative pitch index of snapped y value
        pitchIndex = _.indexOf(@yGrid, y, true);

        # Click is too close to bottom
        if pitchIndex == -1
            return

        @chooserPopup.show
            x: e.layerX
            y: y,
            pitchIndex



        # For now, create glitch at point
        # glitch = new hwfinal.models.instruments.Bubbly
        #     startTime: e.clientX/$(e.currentTarget).width()
        #     x: e.clientX
        #     y: y
        #     pitchIndex: pitchIndex

    

    
    ###
    #   When the orchestra's time is changed, move playhead
    #   to the appropriate position.
    ###
    update_playhead: (orchestra) ->
        @playhead.attr
            x: orchestra.get('t')*100+"%"
    
    create_instrument_controller: (instrument) ->
        instrumentClassName = instrument.namespace.replace "hwfinal.models.instruments.", ""

        instrumentControllerClasses = hwfinal.views.instrumentcontrollers


        instrumentControllerClassMap = 
            "Bubbly": 'BasicCircle'
            "Earth": 'BasicSquare'
            'Prickly': 'AdjustableOval'


        instrumentController = new instrumentControllerClasses[instrumentControllerClassMap[instrumentClassName]]
            instrument: instrument
        
        # Add controller into datastructure
        @instrumentControllers[instrument.get('id')] = instrumentController
