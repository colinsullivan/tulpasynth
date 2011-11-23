###
#   @file       FixedSquareToggleButton.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the MIT license.
###

###
#   @class  Fixed square toggle button.
###
class hwfinal.views.instrumentcontrollers.FixedSquareToggleButton extends Backbone.View

    initialize: (options) ->
        options = options || {}

        @instrument = options.instrument


        @el = $ @el
        @el.attr
            'class': 'instrument glitch disabled'
        
        @instrument.bind 'change', () => 
            @render()
        
    render: () ->
        instrument = @instrument
        
        leftValue = instrument.get('startTime')*1024 - @el.width()/2
        console.log 'leftValue'
        console.log leftValue
        
        @el.css
            left: leftValue

        if instrument.get('disabled') is true
            @disable
        else
            @enable
        
        return this

        
    disable: () ->
        @el.addClass 'disabled'
    
    enable: () ->
        @el.removeClass 'disabled'