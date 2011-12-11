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
        @draggingTimeout = null

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
        #   All objects relating to this controller must reside in this set
        ###
        @all = hwfinal.canvas.set()

        # When instrument's data is changed, re-render        
        @instrument.bind 'change', () => 
            @render()
        
        # When instrument is deleted, delete controller
        # @instrument.bind 'destroy', () =>
        #     console.log '@controller'
        #     console.log @controller
            
        #     @controller.hide()
        #     # delete @
        
        @render()
        @post_render()
    
    render: () ->
        @
    
    _handle_controller_drag_start: (x, y) ->
        @dragging = true

        clearTimeout @draggingTimeout
    
    _handle_controller_drag_end: (e) ->
        console.log "_handle_controller_drag_end"
        @dragging = false

        # After some time
        clearTimeout @draggingTimeout
        @draggingTimeout = setTimeout () =>
            # If the user is still not dragging
            if not @dragging
                # Save the instrument
                @instrument.save()
        , 500

        # setTimeout () =>
        #     @dragging = false
        # , 250

    _handle_controller_drag: (dx, dy, x, y) ->
        snappedY = hwfinal.timeline.snap_y_value y
        pitchIndex = hwfinal.timeline.get_pitch_index snappedY

        @instrument.set
            startTime: x/hwfinal.canvas.width
            y: snappedY
            pitchIndex: pitchIndex
    
    _handle_controller_mousedown: (e) ->
        console.log '_handle_controller_mousedown'
        if @dragging
            return
        else
            @mousedown = true

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

