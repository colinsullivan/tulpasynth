###
#   @file       AdjustableOval.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the MIT license.
###


###
#   @class  Basic class for an oval that has the same width as
#   the sound's duration.
###
class hwfinal.views.instrumentcontrollers.AdjustableOval extends hwfinal.views.instrumentcontrollers.InstrumentController

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

        ovalWidth = duration*hwfinal.canvas.width

        controllerAttrs = 
            fill: 'green'
            cx: startTime*hwfinal.canvas.width + ovalWidth/2
            cy: @instrument.get('y')
            rx: ovalWidth/2
            ry: 15
        if not @controller
            @controller = hwfinal.canvas.ellipse()
            @all.push @controller

        @controller.attr controllerAttrs

        
        handleAttrs = 
            fill: 'white'
            'stroke-width': 2
            r: 5
            cy: @instrument.get('y')
        
        leftHandleAttrs = _.extend
            'cursor': 'ew-resize'
            cx: startTime*hwfinal.canvas.width-ovalWidth/2+2.5
        , handleAttrs

        rightHandleAttrs = _.extend
            cx: startTime*hwfinal.canvas.width+ovalWidth/2-2.5
        , handleAttrs


        if not @leftHandle
            @leftHandle = hwfinal.canvas.circle()
            @all.push @leftHandle

        @leftHandle.attr leftHandleAttrs
        
        if not @rightHandle
            @rightHandle = hwfinal.canvas.circle()
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
        # handleAnimateProperties = 
        #     params:
        #         opacity: 1
        #     ms: 500
        #     easing: '>'
            
        # @leftHandle.animate handleAnimateProperties
        # @rightHandle.animate handleAnimateProperties
        handleAttrs = 
            opacity: 1
        
        @leftHandle.attr handleAttrs
        # @rightHandle.attr handleAttrs
    
    ###
    #   Hide the resize handles.
    ###
    _hide_handles: () ->
        # handleAnimateProperties = 
        #     params:
        #         opacity: 0
        #     ms: 500
        #     easing: '>'

        # @leftHandle.animate handleAnimateProperties
        # @rightHandle.animate handleAnimateProperties

        handleAttrs = 
            opacity: 0
        
        @leftHandle.attr handleAttrs
        @rightHandle.attr handleAttrs

    post_render: () ->
        super

        # @controller.hover () =>
        #     @_show_handles()
        # , () =>
        #     @_hide_handles()

        # @rightHandle.hover () =>
        #     @_show_handles()
        # , () =>
        #     @_hide_handles()
        
        # @leftHandle.hover () =>
        #     @_show_handles()
        # , () =>
        #     @_hide_handles()
        
        # dragStart = () =>
        #     @dragging = true
        #     document.body.style.cursor = "ew-resize"
        # dragEnd = () =>
        #     @dragging = false
        #     @instrument.save()
        #     document.body.style.cursor = "auto"
        
        # # Left handle changes start time of sound
        # @leftHandle.drag (dx, dy, x, y) =>
        #     # Calculate our own dx
        #     dx = x - (@controller.attr('cx') - @controller.attr('rx'))

        #     # startTimeDiff = dx/hwfinal.canvas.width
        #     newStartTime = x/hwfinal.canvas.width

        #     radiusDiff = -1*dx/2
        #     newRadius = @controller.attr('rx') + radiusDiff
        #     newX = @controller.attr('cx')+dx/2

        #     # @controller.attr
        #         # cx: newX
        #         # rx: newRadius
            
        #     @instrument.set
        #         startTime: newStartTime
        #         x: newX
        # , dragStart, dragEnd
        
        # Right handle changes end time
        # @rightHandle.drag (dx, dy, x, y) =>
        #     # Calculate our own dx
        #     dx = x - (@controller.attr('cx') - @controller.attr('rx'))

        #     radiusDiff = -1*dx/2
        #     newRadius = @controller.attr('rx') + radiusDiff
        #     newX = @controller.attr('cx')+dx/2

        #     newEndTime = (x+newRadius*2)/hwfinal.canvas.width

        #     @instrument.set
        #         x: newX
        #         endTime: newEndTime
        # , dragStart, dragEnd



                
            
                

            


    