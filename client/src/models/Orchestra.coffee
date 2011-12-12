###
#   @file       Orchestra.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the GPLv3 license.
###

###
#   @class  The entire "loop" of audio.
#
#   The Orchestra (singleton) contains all of the
#   current instrument instances, as well as the
#   data relating to the synchronization of the 
#   playhead in the loop.
###
class tulpasynth.models.Orchestra extends Backbone.RelationalModel
    relations: [{
        type: Backbone.HasMany,
        key: 'instruments'
        relatedModel: 'tulpasynth.models.instruments.Instrument',
        collectionType: 'tulpasynth.models.instruments.InstrumentCollection',
        reverseRelation:
            key: 'orchestra',
            includeInJSON: false
    }]