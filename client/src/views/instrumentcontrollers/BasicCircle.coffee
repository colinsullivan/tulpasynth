###
#   @file       BasicCircle.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the MIT license.
###

###
#   @class  A basic black circle
###
class hwfinal.views.instrumentcontrollers.BasicCircle extends hwfinal.views.instrumentcontrollers.InstrumentController

    render: () ->
        super

        if not @controller
            @controller = hwfinal.canvas.circle()
            @all.push @controller
        
        @controller.attr
            fill: 'black'
            cx: @instrument.get('startTime')*hwfinal.canvas.width
            cy: hwfinal.timeline.get_y_value @instrument.get('pitchIndex')
            r: 10
        return @