
window.WebSocket = window.WebSocket || window.MozWebSocket || null

ws = null
socket = 'ws://192.168.179.214:9090/'

glitches = [];

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
            glitchUpdate: handle_glitchupdate_message
        
        if messageHandlers[message.type]?
            messageHandlers[message.type] message
        else
            errorMsg = "No handler for message: #{e.data}"
            info errorMsg
            throw new Error errorMsg




handle_sync_message = (message) ->
    $('#playhead').css({'left': message.t*100+"%"});

handle_glitchupdate_message = (message) ->
    glitch = glitches[message.id]

    glitch.disabled = message.disabled

    if glitch.disabled
        glitch.el.addClass 'disabled'
    else
        glitch.el.removeClass 'disabled'

init_ui = () ->
    for i in [0..8]
        glitchElement = $('<div></div>').attr
            'class': 'instrument glitch disabled'

        $('#instruments').append(glitchElement);

        leftValue = i*glitchElement.width() + 2*i
        glitchElement.css({
            left: leftValue
        });

        glitches[i] = 
            disabled: true
            onTime: (leftValue + (glitchElement.width()/2))/1024
            id: i
            el: glitchElement
        
        glitchElement.data({'glitchId': i});

        glitchElement.click () ->
            glitchElement = $(this)
            glitch = glitches[glitchElement.data('glitchId')]

            message = 
                type: 'glitchUpdate'
                id: glitch.id

            if glitch.disabled
                glitch.disabled = false
                glitchElement.removeClass 'disabled'

            else
                glitch.disabled = true
                glitchElement.addClass 'disabled'

            # Update server
            message.disabled = glitch.disabled
            ws.send JSON.stringify message
            
            




$(document).ready () -> 
    init_ui()
    connect()

