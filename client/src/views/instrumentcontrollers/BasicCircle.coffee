###
#   @file       BasicCircle.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the GPLv3 license.
###

###
#   @class  A basic black circle
###
class tulpasynth.views.instrumentcontrollers.BasicCircle extends tulpasynth.views.instrumentcontrollers.InstrumentController

    render: () ->
        super

        if not @controller
            @controller = tulpasynth.canvas.circle()
            @all.push @controller
        
        @controller.attr
            fill: 'black'
            cx: @instrument.get('startTime')*tulpasynth.canvas.width
            cy: tulpasynth.timeline.get_y_value @instrument.get('pitchIndex')
            r: 10
        return @