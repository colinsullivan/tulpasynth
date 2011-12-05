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

        @controller = hwfinal.canvas.rect @instrument.get('x'),
            @instrument.get('y'),
            10,
            10
        
        @controller.attr
            fill: 'black'
        
        @post_render()

        return @