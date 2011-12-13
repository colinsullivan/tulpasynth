###
#   @file       DistortedSnare.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the GPLv3 license.
###

###
#   @class  Distorted percussive snare
###
class tulpasynth.models.instruments.DistortedSnare extends tulpasynth.models.instruments.Instrument
    namespace: 'tulpasynth.models.instruments.DistortedSnare'
    maxInstances: 8

    initialize: () ->

        if not @get 'gain'
            @set
                gain: 0.3
        
        super