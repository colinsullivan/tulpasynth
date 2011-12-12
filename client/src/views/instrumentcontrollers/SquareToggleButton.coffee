###
#   @file       SquareToggleButton.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the MIT license.
###

###
#   @class  Square that can be toggled on and off.
###
class tulpasynth.views.instrumentcontrollers.SquareToggleButton extends tulpasynth.views.instrumentcontrollers.InstrumentController

    initialize: (options) ->
        super
    
    

    render: () ->
        super
        @el = tulpasynth.canvas.circle @instrument.get('startTime')*tulpasynth.canvas.width, tulpasynth.timeline.get_y_value(@instrument.get('pitchIndex')), 10

        return @
    
    

    