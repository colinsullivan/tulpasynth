###
#   @file       ControllerChooserPopup.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the MIT license.
###

###
#   @class  Popup for user to select controller with.
#
#   Displays a popup containing demo versions of each controller
#   type.  When a user selects one of the controllers, it will
#   be placed in the location of the first click with its 
#   corresponding instrument.
###
class hwfinal.views.ControllerChooserPopup extends Backbone.View
    initialize: () ->

        ###
        #   Set of all elements rendered for popup.
        ###
        @set = null

        ###
        #   If the popup is currently visible
        ###
        @active = false

        ###
        #   Current coordinates of pointer arrow
        ###
        @currentArrowCoords = null

        ###
        #   Current pitch index at pointer arrow
        ###
        @currentPitchIndex = null

    ###
    #   Hide popup.
    ###
    hide: () ->
        @set.remove()
        @active = false

    ###
    #   Show popup.
    #
    #   @param  arrowCoords     The coordinates of the popup point.
    #   @param  pitchIndex      Pitch index of popup point.
    ###
    show: (arrowCoords, pitchIndex) ->

        if @active
            @hide()
        
        @currentArrowCoords = arrowCoords
        @currentPitchIndex = pitchIndex

        @set = hwfinal.canvas.set()

        popupDirection = 'up'

        pen = 
            x: arrowCoords.x
            y: arrowCoords.y

        # Make sure popup is drawn on the canvas
        rotateDegrees = 0

        canvasHeight = hwfinal.canvas.height
        canvasWidth = hwfinal.canvas.width        

        # If we're in the top left corner
        if pen.x < 100 && pen.y < 100
            rotateDegrees = 135
            # pen.y += 50
            # pen.x += 25
        # Bottom left corner
        else if pen.x < 100 && canvasHeight-pen.y < 100
            rotateDegrees = 45
            # pen.y -= 75
            # pen.x += 25
        # Bottom right corner
        else if canvasWidth-pen.x < 100 && canvasHeight-pen.y < 100
            rotateDegrees = -45
            # pen.y -= 50
            # pen.x -= 100
        # Top right corner
        else if canvasWidth-pen.x < 100 && pen.y < 100
            rotateDegrees = -135
            # pen.y += 75
            # pen.x -= 50
        # Top edge
        else if pen.y < 100
            rotateDegrees = 180
            # pen.y += 25
        else if pen.x < 100
            rotateDegrees = 90
            # pen.x += 100
            # pen.y += 25
        
        
        pen.x -= 50
        pen.y -= 110

        # Keep track of where we began drawing controller objects
        controllerStart = 
            x: pen.x
            y: pen.y

        

        # Bubbly
        bubblyExample = hwfinal.canvas.circle pen.x, pen.y, 10

        bubblyExample.attr
            fill: 'black'

        bubblyExample.click () =>
            @hide()

            coords = @currentArrowCoords

            new hwfinal.models.instruments.Bubbly
                startTime: coords.x/hwfinal.canvas.width
                x: coords.x
                y: coords.y
                pitchIndex: @currentPitchIndex
        
        @set.push bubblyExample

        pen.x += 25

        # Earth
        earthExample = hwfinal.canvas.rect pen.x, pen.y, 10, 10
        earthExample.attr
            fill: 'black'
        earthExample.click () =>
            @hide()
            coords = @currentArrowCoords
            new hwfinal.models.instruments.Earth
                startTime: coords.x/hwfinal.canvas.width
                x: coords.x
                y: coords.y
                pitchIndex: @currentPitchIndex
        @set.push earthExample

        pen.x += 40

        # Prickly
        pricklyExample = hwfinal.canvas.ellipse pen.x, pen.y, 15, 10
        pricklyExample.attr
            fill: 'green'
        pricklyExample.click () =>
            @hide()
            coords = @currentArrowCoords
            startTime = coords.x/hwfinal.canvas.width
            new hwfinal.models.instruments.Prickly
                startTime: startTime
                endTime: startTime+0.1
                x: coords.x
                y: coords.y
                pitchIndex: @currentPitchIndex
        @set.push pricklyExample




        ###
        #   Now draw box around sample controllers
        ###
        rectWidth = 120
        rectHeight = 100
        # Create popup box
        rectBottomSegmentWidth = (rectWidth/2)-15;
        # Path for the pointy part 
        pathText = 'M';
        # start at center of circle 
        pathText += ' '+arrowCoords.x+' '+arrowCoords.y;

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

        bubble = hwfinal.canvas.path pathText
        @set.push bubble
                
        @set.rotate rotateDegrees, arrowCoords.x, arrowCoords.y


        @active = true
    