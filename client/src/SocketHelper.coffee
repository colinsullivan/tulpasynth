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

            if method == 'response/id'
                # Get id
                id = message.id

                # Get first in line
                model = hwfinal.models.waitingInstances.shift()

                # Give id
                model.set
                    id: id
                
                # Save
                model.save {},
                    method: 'create'
                
            else

                namespaceSplit = message.namespace.split '.'

                modelType = window
                while namespaceSplit.length
                    modelType = modelType[namespaceSplit.shift()]
                
                if _.isUndefined modelType
                    throw new Error "Type #{message.namespace} not found."

                if method == 'update'

                    # Get model instance to update
                    modelInstance = Backbone.Relational.store.find modelType, message.id
                
                    if not modelInstance
                        throw new Error "Model #{message.namespace} id: #{message.id} not found."
        
                    # Update it
                    modelInstance.set message.attributes
                else if method == 'create'
                    
                    console.log "Creating model of #{modelType} with attributes:"
                    console.log message.attributes
                    # Create model
                    modelInstance = new modelType message.attributes
                    
                else
                    throw new Error "Method #{method} not recognized."

    
    send: (messageObject) ->
        message = JSON.stringify messageObject
        console.log 'Sending:'
        console.log message
        console.log '\n'
        
        @socket.send message
