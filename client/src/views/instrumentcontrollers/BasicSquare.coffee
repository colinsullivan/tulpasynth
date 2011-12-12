###
#   @file       BasicSquare.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the MIT license.
###

###
#   @class  Basic black square.
###
class hwfinal.views.instrumentcontrollers.BasicSquare extends hwfinal.views.instrumentcontrollers.InstrumentController

    render: () ->
        super

        if not @controller
            @controller = hwfinal.canvas.rect()
            @all.push @controller
        
        @controller.attr
            fill: 'black'
            x: @instrument.get('startTime')*hwfinal.canvas.width
            y: hwfinal.timeline.get_y_value(@instrument.get('pitchIndex'))
            width: 20
            height: 20

        return @