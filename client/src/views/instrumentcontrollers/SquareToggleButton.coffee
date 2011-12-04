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
class hwfinal.views.instrumentcontrollers.SquareToggleButton extends hwfinal.views.instrumentcontrollers.InstrumentController

    initialize: (options) ->
        super
    
    

    render: () ->
        super
        @el = hwfinal.canvas.circle @instrument.get('x'), @instrument.get('y'), 10

        return @
    
    

    