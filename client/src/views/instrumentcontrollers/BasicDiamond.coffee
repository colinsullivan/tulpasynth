###
#   @file       BasicDiamond.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the GPLv3 license.
###


###
#   @class  Basic diamond shape.
###
class tulpasynth.views.instrumentcontrollers.BasicDiamond extends tulpasynth.views.instrumentcontrollers.InstrumentController

    render: () ->
        super

        if not @controller
            @controller = tulpasynth.canvas.path()
            @all.push @controller
        
        y = tulpasynth.timeline.get_y_value(@instrument.get('pitchIndex'))+10
        x = @instrument.get('startTime')*tulpasynth.canvas.width
        @controller.attr
            fill: 'red'
            path: "M#{x},#{y} l 10,10 l -10,10 l -10,-10 l 10,-10 z "

        @