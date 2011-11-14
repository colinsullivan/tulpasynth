
window.WebSocket = window.WebSocket || window.MozWebSocket || null

ws = null

handle_sync_message = (message) ->
    $("#message").html('Sync message received:<br />t:'+message.t);


$(document).ready () ->
    if window.WebSocket == null
        throw new Error "This browser does not support websockets."
        return false

    ws = new WebSocket 'ws://localhost:9003/'

    ws.onopen = (e) ->
        console.log 'Websocket connection established.'
    
    ws.onerror = (e) ->
        throw new Error e
    
    ws.onclose = (e) ->
        console.log 'Websocket connection closed.'
    
    ws.onmessage = (e) ->

        message = JSON.parse e.data

        messageHandlers = 
            sync: handle_sync_message
        
        messageHandlers[message.type] message
