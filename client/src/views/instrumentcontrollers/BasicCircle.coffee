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
        
        @el = hwfinal.canvas.circle @instrument.get('x'),
            @instrument.get('y'),
            10
        
        @el.attr
            fill: 'black'
        
        return @