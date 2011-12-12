###
#   @file       BackboneSync.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the GPLv3 license.
###

Backbone.sync = (method, model, options) ->

    message =
        namespace: model.namespace
        method: method
        attributes: model.toJSON()
    
    if options.method
        message.method = options.method

    if not options.nosave
        tulpasynth.socket.send message

    options.success()
    


