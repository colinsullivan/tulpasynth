###
#   @file       InstrumentController.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the GPLv3 license.
###

###
#   @class  Base instrument controller class.
###
class tulpasynth.views.instrumentcontrollers.InstrumentController extends Backbone.View
    initialize: (options) ->
        options = options || {}

        @instrument = options.instrument

        ###
        #   controller will be the reference to the RaphaelJS object.
        ###
        @controller = null

        ###
        #   If a part of this controller is currently being dragged.
        ###
        @dragging = false

        ###
        #   We'll save instrument after user stops dragging for
        #   a duration.
        ###
        @draggingSaveTimeout = null

        ###
        #   If the controller is currently being clicked 
        #   (mouse button is held down).
        ###
        @mousedown = false

        ###
        #   We will clear instrument after user has been holding mouse
        #   for a duration.  Here is where we'll store the reference to
        #   the timeout.
        ###
        @mousedownTimeout = null

        ###
        #   Keep track of mouse position relative to BBox of controller.
        ###
        @controllerMousedownPosition =
            x: null
            y: null
        
        @draggingOverRecycleArea = false
        
        ###
        #   All objects relating to this controller must reside in this set
        ###
        @all = tulpasynth.canvas.set()

        # When instrument's data is changed, re-render        
        @instrument.bind 'change', () => 
            @render()
        
        # When instrument is deleted, unbind everything and delete self
        # @instrument.bind 'destroy', () =>
        #     console.log '@controller'
        #     console.log @controller
            
        #     # @controller.hide()
        #     delete @
        
        @render()
        @post_render()
    
    render: () ->
        @
    
    _handle_controller_drag_start: (x, y) ->
        console.log '_handle_controller_drag_start'
        # Show delete area
        tulpasynth.timeline.controllerDeleteArea.show()
        # @all.toFront()
        @dragging = true

        bbox = @controller.getBBox()

        @controllerMousedownPosition.x = x - bbox.x
        # @controllerMousedownPosition.y = y - bbox.y
        

        clearTimeout @draggingSaveTimeout
    
    _handle_controller_drag_end: (e) ->
        console.log "_handle_controller_drag_end"
        # Hide delete area
        tulpasynth.timeline.controllerDeleteArea.hide()

        @dragging = false

        # If we dropped over the delete area
        if @_in_recycle_area(e.x, e.y)
            # Delete instrument
            @instrument.destroy()
        else
            # After some time
            clearTimeout @draggingSaveTimeout
            @draggingSaveTimeout = setTimeout () =>
                # If the user is still not dragging
                if not @dragging
                    # Save the instrument
                    @instrument.save()
            , 500

    
    _in_recycle_area: (x, y) ->
        controllerDeleteArea = tulpasynth.timeline.controllerDeleteArea
        controllerDeleteAreaBBox = controllerDeleteArea.shownBBox
        if x > controllerDeleteAreaBBox.x && x < controllerDeleteAreaBBox.x+controllerDeleteAreaBBox.width && y > controllerDeleteAreaBBox.y && y < controllerDeleteAreaBBox.y+controllerDeleteAreaBBox.height
            return true
        else
            return false


    _handle_controller_drag: (dx, dy, x, y) ->

        # If we're dragging over the recycle area
        if @_in_recycle_area(x, y)
            # inform the recycle area
            tulpasynth.timeline.controllerDeleteArea.handle_drag_over()
            @draggingOverRecycleArea = true
        # If we're no longer dragging over the recycle area, but we just were
        else if @draggingOverRecycleArea
            @draggingOverRecycleArea = false
            tulpasynth.timeline.controllerDeleteArea.handle_drag_over_out()


        # Maintain mouse position relative to element
        x = x - @controllerMousedownPosition.x
        # y = y - @controllerMousedownPosition.y

        snappedY = tulpasynth.timeline.snap_y_value y
        pitchIndex = tulpasynth.timeline.get_pitch_index snappedY

        if pitchIndex == -1
            return

        newStartTime = x/tulpasynth.canvas.width

        attrs = 
            startTime: newStartTime
            y: snappedY
            pitchIndex: pitchIndex
        
        if @instrument.get 'endTime'
            duration = @instrument.get('endTime') - @instrument.get('startTime')
            attrs.endTime = newStartTime+duration

        
        @instrument.set attrs
            
            
    
    # _handle_controller_mousedown: (e) ->
    #     console.log '_handle_controller_mousedown'
    #     if @dragging
    #         return
    #     else
    #         @mousedown = true

            # In 500ms
            # @mousedownTimeout = setTimeout () =>
            #     # If the user is still holding the mouse button down
            #     if @mousedown
            #         # Delete the instrument
            #         console.log "Deleting instrument #{@instrument.get('id')}"
            #         @instrument.destroy()
            # , 500

    # _handle_controller_mouseup: (e) ->
    #     @mousedown = false;

    #     if @mousedownTimeout
    #         clearTimeout @mousedownTimeout
    #         @mousedownTimeout = null
    
    post_render: () ->

        @controller.drag (dx, dy, x, y) =>
            @_handle_controller_drag dx, dy, x, y
        , (x, y) =>
            @_handle_controller_drag_start x, y
        , (e) =>
            @_handle_controller_drag_end e

        # @controller.mousedown (e) =>
        #     @_handle_controller_mousedown e
        
        # @controller.mouseup (e) => 
        #     @_handle_controller_mouseup e

