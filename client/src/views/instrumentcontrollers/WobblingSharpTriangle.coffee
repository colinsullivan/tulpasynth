###
#   @file       WobblingSharpTriangle.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the GPLv3 license.
###

###
#   @class  Rectangle with adjustable edges.
###
class tulpasynth.views.instrumentcontrollers.WobblingSharpTriangle extends tulpasynth.views.instrumentcontrollers.InstrumentController

    initialize: () ->

        ###
        #   Coordinates of top left corner
        ###
        @topLeft = 
            x: null
            y: null
        
        ###
        #   width
        ###
        @width = null

        ###
        #   If we're currently performing wiggling animation
        ###
        @wiggling = false

        @wigglingDirecton = null

        # If orchestra's time is updated
        tulpasynth.orchestra.bind 'change:t', (orchestra) =>
            t = orchestra.get 't'

            # If playhead is on top of our instrument
            playheadX = t*tulpasynth.canvas.width
            if @width? and not @wiggling and playheadX > @topLeft.x and playheadX < @topLeft.x+@width+50

                @_start_wiggling()
            # If playhead is not on top of our instrument and we are
            # wiggling.
            else if @width? and @wiggling and (playheadX < @topLeft.x or playheadX > @topLeft.x+@width+50)
                @_stop_wiggling()
        
        super
            

    _start_wiggling: () ->

        # Begin wiggling animation
        @wigglingDirection = -1
        @_wiggle()

        @wiggling = true
    
    _wiggle: () ->
        @wigglingDirection *= -1

        attrs = 
            # path: "M#{@topLeft.x},#{@topLeft.y} s10,10,#{@width},#{10+@wigglingDirection*10} M#{@topLeft.x},#{@topLeft.y+20} s-10,-10,#{@width},#{-10+@wigglingDirection*10} M#{@topLeft.x},#{@topLeft.y+20} L#{@topLeft.x},#{@topLeft.y} z"
            # path: "M#{@topLeft.x},#{@topLeft.y} s10,10,#{@width},#{10+@wigglingDirection*10} S-10,-10,-#{@topLeft.x},#{@topLeft.y+20} L0,#{@topLeft.y} z"
            path: "M#{@topLeft.x},#{@topLeft.y} s5,5,#{@width},#{10+@wigglingDirection*10} s-5,-5,-#{@width},#{10-@wigglingDirection*10} z"
        @controller.animate attrs, '30', 'linear', () =>
            if @wiggling
                @_wiggle()
            else
                @render()
    
    _stop_wiggling: () ->
        @wiggling = false


    render: () ->
        super

        if not @controller
            @controller = tulpasynth.canvas.path()
            @all.push @controller
        
        @topLeft.x = @instrument.get('startTime')*tulpasynth.canvas.width
        @topLeft.y = tulpasynth.timeline.get_y_value @instrument.get('pitchIndex')

        @width = 150

        attrs = 
            path: "M#{@topLeft.x},#{@topLeft.y} s5,5,#{@width},10 s-5,-5,-#{@width},10 z"
            fill: '90-#0E8A00-#14C900:80-#14C900'
            'stroke-width': 1
            # 'stroke-width': 20
        
        @controller.attr attrs
