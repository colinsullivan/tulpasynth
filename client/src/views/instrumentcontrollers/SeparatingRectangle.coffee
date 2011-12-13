###
#   @file       SeparatingRectangle.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the GPLv3 license.
###

###
#   @class  Rectangle with adjustable edges.
###
class tulpasynth.views.instrumentcontrollers.SeparatingRectangle extends tulpasynth.views.instrumentcontrollers.InstrumentController

    render: () ->
        super

        if not @controller
            @controller = tulpasynth.canvas.path()
            @all.push @controller
        
        leftX = @instrument.get('startTime')*tulpasynth.canvas.width
        leftY = tulpasynth.timeline.get_y_value @instrument.get('pitchIndex')

        length = (@instrument.get('endTime') - @instrument.get('startTime'))*tulpasynth.canvas.width

        attrs = 
            path: "M#{leftX},#{leftY} l #{length},0 z"
            'stroke-width': 15
        
        @controller.attr attrs
