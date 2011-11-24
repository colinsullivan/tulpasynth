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
    
    onready: () ->    
    
    connect: () ->
        if window.WebSocket == null
            throw new Error "This browser does not support websockets."
            return false

        console.log "Attempting to connect to #{@url}"
        socket = new WebSocket @url
        @socket = socket

        socket.onopen = (e) =>
            console.log 'Websocket connection established.'
            @onready()
        
        socket.onerror = (e) =>
            throw new Error e
        
        socket.onclose = (e) =>
            console.log 'Websocket connection closed...Reconnecting...'
            setTimeout(() =>
                @connect()
            , 500);
        
        ###
        #   When the socket receives a synchronization message from the 
        #   server, it updates the appropriate model.
        #
        #   @param  e   Raw event object from websocket.
        ###
        socket.onmessage = (e) =>

            message = JSON.parse e.data

            method = message.method

            namespaceSplit = message.namespace.split '.'

            modelType = window
            while namespaceSplit.length
                modelType = modelType[namespaceSplit.shift()]
                        

            if method == 'update'

                # Get model instance to update
                modelInstance = Backbone.Relational.store.find modelType, message.id
    
                # Update it
                modelInstance.set message.attributes
            else if method == 'create'
                
                console.log 'message'
                console.log message
                
                
            else
                throw new Error "Method #{method} not recognized."

    
    send: (messageObject) ->
        message = JSON.stringify messageObject
        console.log 'Sending:'
        console.log message
        console.log '\n'
        
        @socket.send message
