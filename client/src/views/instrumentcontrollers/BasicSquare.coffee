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
            x: @instrument.get('x')
            y: @instrument.get('y')
            width: 20
            height: 20
        
        @post_render()

        return @