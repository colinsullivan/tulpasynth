###
#   @file       BasicDiamond.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the MIT license.
###


###
#   @class  Basic diamond shape.
###
class hwfinal.views.instrumentcontrollers.BasicDiamond extends hwfinal.views.instrumentcontrollers.InstrumentController

    render: () ->
        super

        if not @controller
            @controller = hwfinal.canvas.path()
            @all.push @controller
        
        y = @instrument.get('y')+10
        @controller.attr
            fill: 'red'
            path: 'M'+(@instrument.get('startTime')*hwfinal.canvas.width)+','+y+' l 10,10 l -10,10 l -10,-10 l 10,-10 z '

        @