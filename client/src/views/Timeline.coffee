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
class tulpasynth.views.Timeline extends Backbone.View
    initialize: () ->
        ###
        #   Our entire timeline canvas.
        ###
        @el = $ '#canvas'

        ###
        #   Timeline background
        ###
        @background = tulpasynth.canvas.rect 0, 0, '100%', '100%'
        
        @background.attr
            fill: 'white'
            "stroke-width": 0

        ###
        #   Height and width of our canvas (hardcoded for now)
        ###
        @height = 768
        @width = 1024

        ###
        #   Grid for placing objects on y-axis
        ###
        @yGrid = []

        # We will have 32 spots in the grid for now
        yGridSize = 32
        @yPxPerGrid = @height/yGridSize

        for i in [0...yGridSize]
            @yGrid.push(i*@yPxPerGrid)
        
        ###
        #   Grid for x-axis (just for drawing currently)
        ###
        @xGrid = []

        xGridSize = @width/32
        @xPxPerGrid = @width/xGridSize

        for i in [0...xGridSize]
            @xGrid.push(i*@xPxPerGrid)
        

        # Draw x-axis grid
        @xGridLines = []
        for i in @xGrid
            gridLine = tulpasynth.canvas.path 'M'+i+',0 L'+i+','+@height+' z'
            gridLine.attr
                'stroke-width': 1
                'opacity': 0.25
            gridLine.node.style["shapeRendering"] = 'crispEdges';
            @xGridLines.push gridLine
        

        ###
        #   Container for our instrument controllers
        ###
        @instrumentControllerContainer = $ '#instruments'

        ###
        #   Playhead is a line on the canvas
        ###
        @playhead = tulpasynth.canvas.path()
        @playhead.attr
            'stroke-width': 1
        @playhead.node.style["shapeRendering"] = "crispEdges";

        ###
        #   Instrument controllers (by `Instrument.id`)
        ###
        @instrumentControllers = {}

        ###
        #   The chooser popup for when a user is selecting a 
        #   controller.
        ###
        @chooserPopup = new tulpasynth.views.ControllerChooserPopup()

        orchestra = tulpasynth.orchestra

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

            controller.all.remove()
            delete controller
            @instrumentControllers[instrument.get('id')] = null
        
        @background.click (e) =>
            @_handle_click e
    
    snap_y_value: (y) ->
        Raphael.snapTo @yGrid, y, @yPxPerGrid/2
    
    get_pitch_index: (snappedY) ->
        _.indexOf @yGrid, snappedY, true
    
    get_y_value: (pitchIndex) ->
        pitchIndex*@yPxPerGrid

    _handle_click: (e) ->
        # Snap y value to grid
        y = @snap_y_value e.layerY

        # Get relative pitch index of snapped y value
        pitchIndex = @get_pitch_index y

        # Click is too close to bottom
        if pitchIndex == -1
            return

        @chooserPopup.show
            x: e.layerX
            y: y,
            pitchIndex



        # For now, create glitch at point
        # glitch = new tulpasynth.models.instruments.Bubbly
        #     startTime: e.clientX/$(e.currentTarget).width()
        #     x: e.clientX
        #     y: y
        #     pitchIndex: pitchIndex

    

    
    ###
    #   When the orchestra's time is changed, move playhead
    #   to the appropriate position.
    ###
    update_playhead: (orchestra) ->
        # console.log 'orchestra.get(\'t\')*@width'
        # console.log orchestra.get('t')*@width

        x = orchestra.get('t')*@width

        @playhead.attr
            path: 'M'+x+',0 L'+x+','+@height
        
        # @playhead.translate orchestra.get('t')*@width
    
    create_instrument_controller: (instrument) ->
        instrumentClassName = instrument.namespace.replace "tulpasynth.models.instruments.", ""

        instrumentControllerClasses = tulpasynth.views.instrumentcontrollers


        instrumentControllerClassMap = 
            "Bubbly": 'BasicCircle'
            "Earth": 'BasicSquare'
            'Prickly': 'AdjustableOval'
            'DistortedSnare': 'BasicDiamond'


        instrumentController = new instrumentControllerClasses[instrumentControllerClassMap[instrumentClassName]]
            instrument: instrument
        
        # Add controller into datastructure
        @instrumentControllers[instrument.get('id')] = instrumentController
