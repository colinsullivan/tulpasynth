colors = require "colors"
net = require("net")


console.log "
 __          __                                     __   __    \n
|  |_.--.--.|  |.-----..---.-..-----..--.--..-----.|  |_|  |--.\n
|   _|  |  ||  ||  _  ||  _  ||__ --||  |  ||     ||   _|     |\n
|____|_____||__||   __||___._||_____||___  ||__|__||____|__|__|\n
                |__|                 |_____|                   \n

".bold

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

server = net.createServer
    allowHalfOpen: false
    , (client) ->
        console.log "Client connected"

        client.on "end", () ->
            console.log "Client disconnected"
        
        client.on "data", (data) ->
            console.log "Data received:\n\n--------\n\n#{data}\n\n--------\n\n"

server.listen 6666, () ->
    console.log "Listening on 6666"
