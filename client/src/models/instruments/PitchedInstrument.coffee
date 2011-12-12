###
#   @file       PitchedInstrument.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the MIT license.
###

###
#   @class  Base class for all instruments that have a pitch.
###
class tulpasynth.models.instruments.PitchedInstrument extends tulpasynth.models.instruments.Instrument

    initialize: (attributes) ->
        ###
        #   The minimum pitch index allowed for this instrument.
        ###
        if not @minPitchIndex?
            @minPitchIndex = 0
        ###
        #   The maximum pitch index allowed for this instrument.
        ###
        if not @maxPitchIndex
            @maxPitchIndex = 32

        super
    
    ###
    #   If pitchIndex is being changed, make sure it is
    #   within bounds.
    ###
    set: (attrs, options) ->
        # If pitch index is being changed
        if attrs?.pitchIndex?
            # And it is out of bounds, leave at min/max
            if attrs.pitchIndex < @minPitchIndex
                attrs.pitchIndex = @minPitchIndex
            if attrs.pitchIndex > @maxPitchIndex
                attrs.pitchIndex = @maxPitchIndex
        
        super