###
#   @file       HarmonicTable.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the MIT license.
###


###
#   @class  Abstraction around harmonic table pitches.
#
#   TODO: Top left pitch
#   Width
#   Height
###
class HarmonicTable extends hwfinal.models.instruments.Instrument

    initialize: (attributes) ->
        attributes = attributes || {}

        if not attributes.firstPitch
            throw new Error "firstPitch required."
        
        if not attributes.width
            throw new Error "width required."
        
        if not attributes.height
            throw new Error "height required"
        
        @generate_table()
    
    generate_table: () ->
        # The 2-d harmonic table
        @table = [];

        # For each row of table
        for x in [0..@get('width')]
            # Need to use MIDI here to generate table rows.
            return
            
    
    
    
    
    
    
    