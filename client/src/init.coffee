###
#   @file       init.coffee
#
#               This file contains initialization code for various
#               things.  It is the first file loaded.
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the MIT license.
###


# Global namespace
window.hwfinal = {
    models: {},
    # Our `SocketHelper` instance
    socket: null,
    # Our `Orchestra` instance
    orchestra: null
}

$(document).ready () ->
    
    # Set up error handler
    window.onerror = (e) ->
        alert e

    # Start listening on our socket
    hwfinal.socket = new hwfinal.SocketHelper 'ws://192.168.179.214:9090'


# handle_sync_message = (message) ->
#     $('#playhead').css({'left': message.t*100+"%"});

# handle_glitchupdate_message = (message) ->
#     glitch = glitches[message.id]

#     glitch.disabled = message.disabled

#     if glitch.disabled
#         glitch.el.addClass 'disabled'
#     else
#         glitch.el.removeClass 'disabled'

# init_ui = () ->
#     for i in [0..8]
#         glitchElement = $('<div></div>').attr
#             'class': 'instrument glitch disabled'

#         $('#instruments').append(glitchElement);

#         leftValue = i*glitchElement.width() + 2*i
#         glitchElement.css({
#             left: leftValue
#         });

#         glitches[i] = 
#             disabled: true
#             onTime: (leftValue + (glitchElement.width()/2))/1024
#             id: i
#             el: glitchElement
        
#         console.log glitches[i].onTime
        
#         glitchElement.data({'glitchId': i});

#         # Tell server to create glitch instrument with given properties
#         # glitch = glitches[i]
#         # message = 
#         #     type: 'glitchCreate'
#         #     id: glitch.id
#         #     onTime: glitch.onTime
#         #     disabled: glitch.disabled
#         # socket.send JSON.stringify message

#         glitchElement.click () ->
#             glitchElement = $(this)
#             glitch = glitches[glitchElement.data('glitchId')]

#             message = 
#                 type: 'glitchUpdate'
#                 id: glitch.id

#             if glitch.disabled
#                 glitch.disabled = false
#                 glitchElement.removeClass 'disabled'

#             else
#                 glitch.disabled = true
#                 glitchElement.addClass 'disabled'

#             # Update server
#             message.disabled = glitch.disabled
#             socket.send JSON.stringify message
