colors = require "colors"
net = require "net"
redis = require "redis"
WebSocket = require "faye-websocket"
http = require "http"


console.log "
 __          __                                     __   __    \n
|  |_.--.--.|  |.-----..---.-..-----..--.--..-----.|  |_|  |--.\n
|   _|  |  ||  ||  _  ||  _  ||__ --||  |  ||     ||   _|     |\n
|____|_____||__||   __||___._||_____||___  ||__|__||____|__|__|\n
                |__|                 |_____|                   \n

".bold

debugMsg = (msg) ->
    console.log "info".cyan+" - "+msg

errorMsg = (msg) ->
    console.log "error".bold.red+" - "+msg

###
#   Maintain a list of currently open connections, identified by
###
openConnections = []

db = redis.createClient()
db.on "ready", () ->
    debugMsg "Redis connection ready"

    if not db.exists("next_id")
        db.set("next_id", "1")


    server = http.createServer();

    server.addListener 'upgrade', (request, socket, head) ->
        ws = new WebSocket request, socket, head
        openConnections.push ws

        ws.onopen = (event) ->
            debugMsg "Client connected"

            # Get current state
            db.hgetall "model", (err, obj) ->
                if err
                    throw err
                
                console.log 'obj'
                console.log obj

                for id, model of obj
                    message = JSON.parse(model)
                    message.method = "create"
                    ws.send JSON.stringify(message)
                    
                

        ws.onmessage = (event) ->
            data = JSON.parse(event.data)
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
            
                    ws.send JSON.stringify(response)

                    debugMsg "Data written:"
                    console.log response
            
            else if data.method == "create"
                # Store data in redis
                delete data.method
                debugMsg "Storing model #{data.attributes.id}"
                db.hmset "model", "#{data.attributes.id}", JSON.stringify(data)

        
        # ws.send event.data

        ws.onclose = (event) ->
            debugMsg 'Client disconnected'
            ws = null
    
    server.on "listening", () ->
        debugMsg "Server listening on port 6666"

    server.on "error", (e) ->
        if e.code == "EADDRINUSE"
            errorMsg "Address in use, retrying..."
            setTimeout () ->
                server.close()
                server.listen 6666, "128.12.158.62"
            , 1000
    
    server.listen 6666, "128.12.158.62"

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

