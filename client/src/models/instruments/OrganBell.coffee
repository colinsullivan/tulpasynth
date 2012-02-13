###
#   @file       OrganBell.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the GPLv3 license.
###

###
#   @class  Organ bell instrument.
###
class tulpasynth.models.instruments.OrganBell extends tulpasynth.models.instruments.PitchedInstrument

    namespace: 'tulpasynth.models.instruments.OrganBell'
    maxInstances: 8

    initialize: (attributes) ->

        if not @get "gain"
            @set
                'gain': 0.10
        
        
        super