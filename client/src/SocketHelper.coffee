###
#   @file       SocketHelper.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the MIT license.
###

window.WebSocket = window.WebSocket || window.MozWebSocket || null

###
#   @class  A helper class to encapsulate socket connection.
###
class hwfinal.SocketHelper
    ###
    #   @param  url     The URL to connect the socket to.
    ###
    constructor: (@url) ->

        @connect()
    
    connect: () ->
        if window.WebSocket == null
            throw new Error "This browser does not support websockets."
            return false

        console.log "Attempting to connect to #{@url}"
        socket = new WebSocket @url

        socket.onopen = (e) =>
            console.log 'Websocket connection established.'
        
        socket.onerror = (e) =>
            throw new Error e
        
        socket.onclose = (e) =>
            console.log 'Websocket connection closed.'
            setTimeout(() =>
                @connect()
            , 500);
        
        socket.onmessage = (e) =>

            message = JSON.parse e.data
            
            # The model instance to update
            modelInstance = Backbone.Relational.store.find hwfinal.models[message.type], message.id

            # Update it
            modelInstance.set message.attributes
            # messageHandlers = 
            #     sync: handle_sync_message
            #     glitchUpdate: handle_glitchupdate_message
            
            # if messageHandlers[message.type]?
            #     messageHandlers[message.type] message
            # else
            #     throw new Error "No handler for message: #{e.data}"