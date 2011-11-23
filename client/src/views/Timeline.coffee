###
#   @file       Timeline.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the MIT license.
###


###
#   @class  Master view, Timeline and all Instrument rendering.
###
class hwfinal.views.Timeline extends Backbone.View
    initialize: () ->
        ###
        #   Our entire timeline canvas.
        ###
        @el = $('#canvas');

        ###
        #   Playhead element (only one)
        ###
        @playheadElement = $('#playhead');

        # If orchestra's time is updated
        hwfinal.orchestra.bind 'change:t', (orchestra) =>
            # Render accordingly
            @update_playhead orchestra
    
    ###
    #   When the orchestra's time is changed, move playhead
    #   to the appropriate position.
    ###
    update_playhead: (orchestra) ->
        @playheadElement.css
            'left': orchestra.get('t')*100+"%"