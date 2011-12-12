###
#   @file       BasicOval.coffee
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
class tulpasynth.views.instrumentcontrollers.BasicOval extends tulpasynth.views.instrumentcontrollers.InstrumentController

    render: () ->
        super

        startTime = @instrument.get 'startTime'
        endTime = @instrument.get 'endTime'

        duration = endTime - startTime

        width = duration*tulpasynth.canvas.width

        @controller = tulpasynth.canvas.ellipse startTime*tulpasynth.canvas.width, tulpasynth.timeline.get_y_value(@instrument.get('pitchIndex')), width/2, 15
        
        @controller.attr
            fill: 'green'
        
        @post_render()

        @