###
#   @file       BasicSquare.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the GPLv3 license.
###

###
#   @class  Basic black square.
###
class tulpasynth.views.instrumentcontrollers.BasicSquare extends tulpasynth.views.instrumentcontrollers.InstrumentController

    render: () ->
        super

        if not @controller
            @controller = tulpasynth.canvas.rect()
            @all.push @controller
        
        @controller.attr
            fill: '90-#0038BA-#1659F5:80-#1659F5'
            "stroke-width": 1
            x: @instrument.get('startTime')*tulpasynth.canvas.width
            y: tulpasynth.timeline.get_y_value(@instrument.get('pitchIndex'))
            width: 20
            height: 20

        return @