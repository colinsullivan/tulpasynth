###
#   @file       ControllerChooserPopup.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the GPLv3 license.
###

###
#   @class  Popup for user to select controller with.
#
#   Displays a popup containing demo versions of each controller
#   type.  When a user selects one of the controllers, it will
#   be placed in the location of the first click with its 
#   corresponding instrument.
###
class tulpasynth.views.ControllerChooserPopup extends Backbone.View
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
            return
        
        @currentArrowCoords = arrowCoords
        @currentPitchIndex = pitchIndex

        @set = tulpasynth.canvas.set()

        pen = 
            x: arrowCoords.x
            y: arrowCoords.y

        # Make sure popup is drawn on the canvas
        rotateDegrees = 0

        canvasHeight = tulpasynth.canvas.height
        canvasWidth = tulpasynth.canvas.width        

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

        orchestra = tulpasynth.orchestra
        instrumentType = tulpasynth.models.instruments.Bubbly
        if orchestra.new_instrument_allowed(instrumentType)
            # Bubbly
            bubblyExample = tulpasynth.canvas.circle pen.x, pen.y, 10

            bubblyExample.attr
                fill: '90-#00AB86-#02DEAE:80-#02DEAE'
                'stroke-width': 1

            bubblyExample.click () =>
                @hide()

                coords = @currentArrowCoords

                new tulpasynth.models.instruments.Bubbly
                    startTime: coords.x/tulpasynth.canvas.width
                    x: coords.x
                    y: coords.y
                    pitchIndex: @currentPitchIndex
            
            @set.push bubblyExample

        pen.x += 20
        pen.y -= 10

        instrumentType = tulpasynth.models.instruments.Earth
        if orchestra.new_instrument_allowed(instrumentType)
            # Earth
            earthExample = tulpasynth.canvas.rect pen.x, pen.y, 20, 20
            earthExample.attr
                fill: '90-#0038BA-#1659F5:80-#1659F5'
                "stroke-width": 1
            earthExample.click () =>
                @hide()
                coords = @currentArrowCoords
                new tulpasynth.models.instruments.Earth
                    startTime: coords.x/tulpasynth.canvas.width
                    x: coords.x
                    y: coords.y
                    pitchIndex: @currentPitchIndex
            @set.push earthExample

        pen.x += 10
        pen.y += 30

        instrumentType = tulpasynth.models.instruments.DistortedSnare
        if orchestra.new_instrument_allowed(instrumentType)
            # DistortedSnare
            snareExample = tulpasynth.canvas.path 'M'+pen.x+','+pen.y+' l 10,10 l -10,10 l -10,-10 l 10,-10z'
            snareExample.attr
                fill: 'red'
            snareExample.click () =>
                @hide()
                coords = @currentArrowCoords
                startTime = coords.x/tulpasynth.canvas.width
                new tulpasynth.models.instruments.DistortedSnare
                    startTime: startTime
                    x: coords.x
                    y: coords.y
                    pitchIndex: @currentPitchIndex
            @set.push(snareExample)

        pen.x += 35
        pen.y -= 20

        instrumentType = tulpasynth.models.instruments.Prickly
        if orchestra.new_instrument_allowed(instrumentType)
            # Prickly
            pricklyExample = tulpasynth.canvas.ellipse pen.x, pen.y, 15, 10
            pricklyExample.attr
                fill: '90-#C47300-#FF9500:80-#FF9500'
                'stroke-width': 1
            pricklyExample.click () =>
                @hide()
                coords = @currentArrowCoords
                startTime = coords.x/tulpasynth.canvas.width
                new tulpasynth.models.instruments.Prickly
                    startTime: startTime
                    endTime: startTime+0.11
                    x: coords.x
                    y: coords.y
                    pitchIndex: @currentPitchIndex
            @set.push pricklyExample
        
        pen.y += 20
        pen.x -= 15

        instrumentType = tulpasynth.models.instruments.OrganBell
        if orchestra.new_instrument_allowed(instrumentType)
            # Organ bell
            organBellExample = tulpasynth.canvas.path()
            organBellExample.attr
                path: "M#{pen.x},#{pen.y} s2.5,2.5,30,10 s-2.5,-2.5,-30,10 z"
                fill: '90-#0E8A00-#14C900'
                'stroke-width': 1
                # transform: 's0.5,0.5'

            
            organBellExample.click () =>
                @hide()
                coords = @currentArrowCoords
                startTime = coords.x/tulpasynth.canvas.width
                new instrumentType
                    startTime: startTime
                    # endTime: startTime+0.11
                    x: coords.x
                    y: coords.y
                    pitchIndex: @currentPitchIndex

            @set.push organBellExample


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

        bubble = tulpasynth.canvas.path pathText    
        @set.push bubble
                
        @set.rotate rotateDegrees, arrowCoords.x, arrowCoords.y


        @active = true
    