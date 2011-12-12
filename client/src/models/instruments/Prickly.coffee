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
class hwfinal.models.instruments.Prickly extends hwfinal.models.instruments.PitchedInstrument

    namespace: 'hwfinal.models.instruments.Prickly'

    initialize: (attributes) ->
        
        @minPitchIndex = 16

        super