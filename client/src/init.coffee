
window.WebSocket = window.WebSocket || window.MozWebSocket || null

ws = null

$(document).ready () ->
    if window.WebSocket == null
        throw new Error "This browser does not support websockets."
    else
        ws = new WebSocket 'ws://localhost:9003/socket'