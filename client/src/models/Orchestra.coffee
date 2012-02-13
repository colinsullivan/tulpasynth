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

    initialize: () ->
        ###
        #   Keep track of the amount of instances of each.
        ###
        @numInstruments = {}

        @bind 'add:instruments', (instrument) =>
            @numInstruments[instrument.namespace] = @numInstruments[instrument.namespace] || 0
            @numInstruments[instrument.namespace]++
        
        @bind 'remove:instruments', (instrument) =>
            @numInstruments[instrument.namespace]--
    
    ###
    #   Wether or not the creation of a new instrument of the given 
    #   type is allowed.
    ###
    new_instrument_allowed: (instrumentType) ->
        namespace = instrumentType.prototype.namespace
        maxAllowed = instrumentType.prototype.maxInstances
        
        @numInstruments[namespace] = @numInstruments[namespace] || 0

        return @numInstruments[namespace] < maxAllowed
        

