###
#   @file       Bubbly.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the GPLv3 license.
###


###
#   @class  Short bubbly percussive sound.
###
class tulpasynth.models.instruments.Bubbly extends tulpasynth.models.instruments.PitchedInstrument
    
    namespace: "tulpasynth.models.instruments.Bubbly"

    initialize: (attributes) ->
        @maxPitchIndex = 14
        super