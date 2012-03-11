#!/usr/bin/env coffee

colors = require "colors"
net = require "net"
redis = require "redis"
WebSocket = require "faye-websocket"
http = require "http"
argv = require("optimist").argv;

tulpasynth = require "./lib/tulpasynth.coffee"
require "./lib/ShooterModel.coffee"



console.log "
 __          __                                     __   __    \n
|  |_.--.--.|  |.-----..---.-..-----..--.--..-----.|  |_|  |--.\n
|   _|  |  ||  ||  _  ||  _  ||__ --||  |  ||     ||   _|     |\n
|____|_____||__||   __||___._||_____||___  ||__|__||____|__|__|\n
                |__|                 |_____|                   \n

".bold

SERVER_IP = argv.address || "128.12.158.62"
SERVER_PORT = argv.port || 6666

debugMsg = (msg) ->
    console.log "info".cyan+" - "+msg

errorMsg = (msg) ->
    console.log "error".bold.red+" - "+msg

###
#   Maintain a list of currently open connections, identified by an arbitrary
#   counter.
###
connectionId = 1
openConnections = []

serverStartTime = new Date();

sendToAll = (data) ->
    debugMsg "Sending to all:"
    console.log data

    message = JSON.stringify data

    for connectionId, client of openConnections
        client.send message

sendToAllButOne = (data, one) ->
    debugMsg "Sending to all but one:"
    console.log data

    message = JSON.stringify data

    for connectionId, client of openConnections
        if client != one
            client.send message

sendToOne = (data, one) ->
    debugMsg "Sending to one:"
    console.log data
    message = JSON.stringify data

    one.send message

unpauseAll = () ->
    # Unpause all clients
    message = 
        method: "unpause"

    sendToAll message


db = redis.createClient()
db.on "ready", () ->
    debugMsg "Redis connection ready"

    if not db.exists("next_id")
        db.set("next_id", "1")


    server = http.createServer();

    server.addListener 'upgrade', (request, socket, head) ->
        ws = new WebSocket request, socket, head
        ws.connectionId = connectionId
        openConnections[connectionId++] = ws

        ws.onopen = (event) ->
            debugMsg "Client #{ws.connectionId} connected"
            debugMsg "#{Object.keys(openConnections).length} connections now open"

            # # Get current state
            # db.hgetall "model", (err, obj) ->
            #     if err
            #         throw err
                
            #     console.log 'obj'
            #     console.log obj

            #     for id, model of obj
            #         message = JSON.parse(model)
            #         message.method = "create"
            #         ws.send JSON.stringify(message)
                    
                

        ws.onmessage = (event) ->
            data = JSON.parse(event.data)

            if data.time
                temp = new Date()
                temp.setTime(data.time*1000)
                data.time = temp

            debugMsg "Data received:"
            console.log data

            response = {}

            if data.method == "request_id"
                response.method = "response_id"

                # Get next id
                db.get "next_id", (err, nextId) =>
                    response.id = nextId

                    # Increment next id
                    db.incr("next_id")
            
                    sendToOne response, ws

            
            else if data.method == "create"
                # Store data in redis
                delete data.method
                debugMsg "Storing model #{data.attributes.id}"
                db.hmset "model", "#{data.attributes.id}", JSON.stringify(data)

                # If this is a shooter model, we'll need to synchronize
                # shooting times.
                if data.class is "ShooterModel"
                    debugMsg "Creating a ShooterModel on server"
                    shooter = new tulpasynth.models.ShooterModel data.attributes
                    data.attributes.nextShotTime = shooter.get("nextShotTime")

                    # Update initial client
                    data.method = "update"
                    sendToOne data, ws

                    # When shooter updates the next shot time
                    shooter.on "change:nextShotTime", () =>
                        # Inform all clients
                        message =
                            method: "update"
                            class: "ShooterModel"
                            attributes: shooter.attributes
                        sendToAll message

                # Relay create message to other connected clients
                data.method = "create"
                sendToAllButOne data, ws
                # unpauseAll()


            
            else if data.method == "update"
                # Update data in redis
                delete data.method
                debugMsg "Updating model #{data.attributes.id}"

                if data.class is "ShooterModel"
                    delete data.attributes.nextShotTime

                db.hmset "model", "#{data.attributes.id}", JSON.stringify(data)

                if tulpasynth.modelInstances[data.attributes.id]
                    tulpasynth.modelInstances[data.attributes.id].set data.attributes

                # Relay update message to other connected clients
                data.method = "update"
                sendToAllButOne data, ws

                # unpauseAll()

        
        # ws.send event.data

        ws.onclose = (event) ->
            debugMsg "Client #{ws.connectionId} disconnected"
            delete openConnections[ws.connectionId]
            debugMsg "#{Object.keys(openConnections).length} connections now open"
            ws = null
    
    server.on "listening", () ->
        debugMsg "Server listening on #{SERVER_IP}:#{SERVER_PORT}"

    server.on "error", (e) ->
        if e.code == "EADDRINUSE"
            errorMsg "Address in use error."
            # setTimeout () ->
            #     try
            #         server.close()
            #     catch error
            #         return
            #     finally
            #         server.listen 6666, "128.12.158.62"
            # , 1000
    
    debugMsg "Attempting to listen on #{SERVER_IP}:#{SERVER_PORT}"
    server.listen SERVER_PORT, SERVER_IP

db.on "error", () ->
    console.log "Redis connection error"


# console.log "   info  - ".cyan + "Opening socket on port 6666"
# io = require("socket.io").listen(6666)

# io.sockets.on "connection", (socket) ->
#     socket.on "msg", () ->
#         console.log "message received"



# socket = ws.createServer()
#     # debugMsg: true
#     # version: "draft75"

# socket.addListener "connection", (connection) ->
    
#     console.log "Connection established"

#     connection.addListener "message", (msg) ->
#         console.log "Message received: #{msg}"

# socket.listen(6666);

    


#     server = net.createServer (socket) ->
#         console.log "Client connected"

#         socket.on "end", () ->
#             console.log "Client disconnected"
        
#         socket.on "data", (data) ->


#     server.listen 6666, () ->
#         console.log "Listening on 6666"

