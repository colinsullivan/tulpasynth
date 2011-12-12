###
#   @file       Prickly.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the GPLv3 license.
###


###
#   @class  Prickly instrument
###
class tulpasynth.models.instruments.Prickly extends tulpasynth.models.instruments.PitchedInstrument

    namespace: 'tulpasynth.models.instruments.Prickly'
    maxInstances: 25


    initialize: (attributes) ->
        
        @minPitchIndex = 16

        super