###
#   @file       Earth.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the GPLv3 license.
###


###
#   @class  A deep percussive sound.
###
class tulpasynth.models.instruments.Earth extends tulpasynth.models.instruments.Instrument

    namespace: 'tulpasynth.models.instruments.Earth'
    maxInstances: 8

    initialize: () ->

        if not @get 'gain'
            @set
                gain: 0.25
        
        super