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
        #   The current popup (Raphael.set of objects)
        #   if one is open.
        ###
        @popupSet = null

        orchestra = hwfinal.orchestra

        # If orchestra's time is updated
        orchestra.bind 'change:t', (orchestra) =>
            # Render accordingly
            @update_playhead orchestra
        
        # If an instrument is added to the orchestra
        orchestra.bind 'add:instruments', (instrument) =>
            @create_instrument_controller instrument
        
        @delegateEvents()
    
    events: 
        "click": "_handle_click"
    
    _handle_click: (e) ->
        # Snap y value to grid
        y = Raphael.snapTo(@yGrid, e.clientY, @yPxPerGrid/2);

        # Get relative pitch index
        pitchIndex = _.indexOf(@yGrid, y, true);

        if pitchIndex == -1
            return

        @_show_controllers_popup e.clientX, y

        # For now, create glitch at point
        # glitch = new hwfinal.models.instruments.Bubbly
        #     startTime: e.clientX/$(e.currentTarget).width()
        #     x: e.clientX
        #     y: y
        #     pitchIndex: pitchIndex
    
    _show_controllers_popup: (startPointX, startPointY) ->
        @popupSet = hwfinal.canvas.set()

        ###
        #   Create sample versions of controllers
        ###

        pen = 
            x: startPointX-75
            y: startPointY-100

        # Make sure popup is drawn on the canvas
        if pen.x < 25
            pen.x = startPointX+75
        if pen.y < 25
            pen.y = startPointY+100
        
        # Keep track of where we began drawing controller objects
        controllerStart = 
            x: pen.x
            y: pen.y

        # SquareToggleButton
        squareToggleButtonExample = hwfinal.canvas.rect pen.x, pen.y, 10, 10
        
        @popupSet.push squareToggleButtonExample

        ###
        #   Now draw box around sample controllers
        ###
        rectWidth = (pen.x+25) - (controllerStart.x-25)
        rectHeight = (pen.y+25) - (controllerStart.y-25)
        # Create popup box
        rectBottomSegmentWidth = (rectWidth/2)-15;
        # Path for the pointy part 
        pathText = 'M';
        # start at center of circle 
        pathText += ' '+startPointX+' '+startPointY;
        # diagonal line up 45 degrees 
        pathText += ' l 15 -15';
        # Right textWidth/2 
        pathText += ' '+rectBottomSegmentWidth+' 0';
        # Rounded bottom right corner 
        pathText += ' a -10,-10 30 0,0 10,-10 ';
        # right side of box 
        pathText += ' l 0 -'+rectHeight;
        # Rounded top-right corner 
        pathText += ' a -10,-10 30 0,0 -10,-10';
        # Top edge 
        pathText += ' l -'+rectWidth+' 0 ';
        # Rounded top-left corner 
        pathText += ' a -10,-10 30 0,0 -10,10';
        # Left side 
        pathText += ' l 0 '+rectHeight;
        # bottom left corner 
        pathText += ' a -10,-10 30 0,0 10,10';
        # bottom edge (left) 
        pathText += ' l '+rectBottomSegmentWidth+' 0';
        pathText += ' z';

        @popupSet.push(hwfinal.canvas.path pathText)
    
    

    
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
            "Bubbly": instrumentControllerClasses['SquareToggleButton']


        instrumentController = new instrumentControllerClassMap[instrumentClassName]
            instrument: instrument
        
        # Add controller into datastructure
        @instrumentControllers[instrument.get('id')] = instrumentController

        # Add controller onto timeline
        # @instrumentControllerContainer.append instrumentController.el

        # Render
        instrumentController.render()

