###
#   @file       Instrument.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the MIT license.
###

###
#   @class  Base class for all instruments.
###
class hwfinal.models.instruments.Instrument extends Backbone.RelationalModel

    ###
    #   All instruments must include their namespace as a string
    ###
    namespace: 'hwfinal.models.instruments.Instrument'


###
#   @class  A set of instrument instances.
###
class hwfinal.models.instruments.InstrumentCollection extends Backbone.Collection