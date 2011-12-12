###
#   @file       AdjustableOval.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the GPLv3 license.
###


###
#   @class  Basic class for an oval that has the same width as
#   the sound's duration.
###
class tulpasynth.views.instrumentcontrollers.AdjustableOval extends tulpasynth.views.instrumentcontrollers.InstrumentController

    initialize: (options) ->

        ###
        #   Resize handles on left and right of oval.
        ###
        @leftHandle = null
        @rightHandle = null

        ###
        #   If we're currently dragging the handles
        ###
        @dragging = false

        super options

    render: () ->
        super

        startTime = @instrument.get 'startTime'
        endTime = @instrument.get 'endTime'

        duration = endTime - startTime

        ovalWidth = duration*tulpasynth.canvas.width

        y = tulpasynth.timeline.get_y_value @instrument.get('pitchIndex')

        controllerAttrs = 
            fill: 'green'
            cx: startTime*tulpasynth.canvas.width + ovalWidth/2
            cy: y
            rx: ovalWidth/2
            ry: 15
        if not @controller
            @controller = tulpasynth.canvas.ellipse()
            @all.push @controller

        @controller.attr controllerAttrs

        
        handleAttrs = 
            fill: 'white'
            'stroke-width': 2
            r: 5
            cy: y
            'cursor': 'ew-resize'
        
        leftHandleAttrs = _.extend
            cx: startTime*tulpasynth.canvas.width+1
        , handleAttrs

        rightHandleAttrs = _.extend
            cx: endTime*tulpasynth.canvas.width-1
        , handleAttrs


        if not @leftHandle
            @leftHandle = tulpasynth.canvas.circle()
            @all.push @leftHandle

        @leftHandle.attr leftHandleAttrs
        
        if not @rightHandle
            @rightHandle = tulpasynth.canvas.circle()
            @all.push @rightHandle

        @rightHandle.attr rightHandleAttrs

        # Handles should be in front of oval
        @leftHandle.toFront()
        @rightHandle.toFront()

        if not @dragging        
            @_hide_handles()

        @

    ###
    #   Reveal the resize handles on left and right side of oval.
    ###
    _show_handles: () ->
        handleAttrs = 
            # opacity: 1
            r: 5

        
        # @leftHandle.attr handleAttrs
        # @rightHandle.attr handleAttrs

        @leftHandle.animate handleAttrs, 250, 'bounce'
        @rightHandle.animate handleAttrs, 250, 'bounce'

    
    ###
    #   Hide the resize handles.
    ###
    _hide_handles: (e) ->

        # If we simply hovered between elements on our 
        if e? and e.toElement? and (e.toElement == @leftHandle.node || e.toElement == @rightHandle.node || e.toElement == @controller.node)
            return
        
        # handleAnimateProperties = 
        #     params:
        #         opacity: 0
        #     ms: 500
        #     easing: '>'

        # @leftHandle.animate handleAnimateProperties
        # @rightHandle.animate handleAnimateProperties

        handleAttrs = 
            # opacity: 0
            r: 0
        
        @leftHandle.attr handleAttrs
        @rightHandle.attr handleAttrs

    post_render: () ->
        super

        @controller.hover (e) =>
            @_show_handles(e)
        , (e) =>
            @_hide_handles(e)

        @rightHandle.hover (e) =>
            @_show_handles(e)
        , (e) =>
            @_hide_handles(e)
        
        @leftHandle.hover (e) =>
            @_show_handles(e)
        , (e) =>
            @_hide_handles(e)
        
        dragStart = () =>
            @dragging = true
            document.body.style.cursor = "ew-resize"
        dragEnd = () =>
            @dragging = false
            @instrument.save()
            document.body.style.cursor = "auto"
        
        # Left handle changes start time of sound
        @leftHandle.drag (dx, dy, x, y) =>
            @instrument.set
                startTime: x/tulpasynth.canvas.width
        , dragStart, dragEnd
        
        # Right handle changes end time
        @rightHandle.drag (dx, dy, x, y) =>
            @instrument.set
                endTime: x/tulpasynth.canvas.width
        , dragStart, dragEnd
