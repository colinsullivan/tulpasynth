###
#   @file       BasicOval.coffee
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
class hwfinal.views.instrumentcontrollers.BasicOval extends hwfinal.views.instrumentcontrollers.InstrumentController

    render: () ->
        super

        startTime = @instrument.get 'startTime'
        endTime = @instrument.get 'endTime'

        duration = endTime - startTime

        width = duration*hwfinal.canvas.width

        @controller = hwfinal.canvas.ellipse startTime*hwfinal.canvas.width, hwfinal.timeline.get_y_value(@instrument.get('pitchIndex')), width/2, 15
        
        @controller.attr
            fill: 'green'
        
        @post_render()

        @