###
#   @file       Prickly.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the MIT license.
###


###
#   @class  Prickly instrument
###
class hwfinal.models.instruments.Prickly extends hwfinal.models.instruments.Instrument

    namespace: 'hwfinal.models.instruments.Prickly'

    ###
    #   Override set method so we can make sure duration isn't
    #   being set too small.
    ###
    set: (attrs, options) ->
        # If duration is being changed
        if attrs? and (attrs.startTime? or attrs.endTime?)
            startTime = attrs.startTime || this.get 'startTime'
            endTime = attrs.endTime || this.get 'endTime'
            
            # And it is going to be changed to too small of a value
            if endTime - startTime < 0.09
                # Do nothing.
                return
        # If we've gotten to here, new values are approved.
        super