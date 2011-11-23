###
#   @file       BackboneSync.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the MIT license.
###

Backbone.sync = (method, model, options) ->

    message =
        namespace: model.namespace
        method: method
        attributes: model.toJSON()
    
    hwfinal.socket.send message
    

