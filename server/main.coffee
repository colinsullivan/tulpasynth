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


client = redis.createClient()
client.on "ready", () ->
    console.log "Redis connection ready"

    if not client.exists("next_id")
        client.set("next_id", "1")


    server = http.createServer();

    server.addListener 'upgrade', (request, socket, head) ->
        ws = new WebSocket request, socket, head

        ws.onmessage = (event) ->
            data = JSON.parse(event.data)
            console.log "Data received:\n\n--------\n\n"
            console.log data
            console.log "\n\n--------\n\n"

            response = {}

            if data.method == "request_id"
                response.method = "response_id"

                # Get next id
                client.get "next_id", (err, nextId) =>
                    response.id = nextId

                    # Increment next id
                    client.incr("next_id")
            
                    ws.send JSON.stringify(response)+"\n"
                    
                    console.log "Data written:\n\n--------\n\n"
                    console.log response
                    console.log "\n\n--------\n\n"

        
        # ws.send event.data

        ws.onclose = (event) ->
            console.log 'close', event.code, event.reason
            ws = null

    server.listen 6666

client.on "error", () ->
    console.log "Redis connection error"


# console.log "   info  - ".cyan + "Opening socket on port 6666"
# io = require("socket.io").listen(6666)

# io.sockets.on "connection", (socket) ->
#     socket.on "msg", () ->
#         console.log "message received"



# socket = ws.createServer()
#     # debug: true
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

