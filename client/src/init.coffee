
window.WebSocket = window.WebSocket || window.MozWebSocket || null

ws = null
socket = 'ws://basillamus.stanford.edu:9090/'

info = (msg) ->
  $('#info').html(msg);

connect = () ->
    if window.WebSocket == null
        errorMsg = "This browser does not support websockets."
        info errorMsg
        throw new Error errorMsg
        return false

    info "Attempting to connect to "+socket
    ws = new WebSocket socket

    ws.onopen = (e) ->
        info 'Websocket connection established.'
    
    ws.onerror = (e) ->
        throw new Error e
    
    ws.onclose = (e) ->
        info 'Websocket connection closed.'
        setTimeout(connect, 500);
    
    ws.onmessage = (e) ->

        message = JSON.parse e.data

        messageHandlers = 
            sync: handle_sync_message
        
        messageHandlers[message.type] message




handle_sync_message = (message) ->
    $('#playhead').css({'left': message.t*100+"%"});


$(document).ready connect