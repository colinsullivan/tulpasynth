var url = 'ws://localhost:9003/sound';
var ws = null;

var context = null;
var audio = null;

function connect() {
    console.log('Connecting to: '+url);

    if("AudioContext" in window) {
        context = new AudioContext();
    }
    else if("webkitAudioContext" in window) {
        context = new webkitAudioContext();

        window.AudioBuffer = window.webkitAudioBuffer;
    }
    else {
        info_message("This browser does not suport AudioContext");
    }

    
    audio = context.createBufferSource();
    audio.loop = 1;
    audio.noteOn(0);
    audio.connect(context.destination);

    
    if ("WebSocket" in window) {
        ws = new WebSocket(url);
    } else if ("MozWebSocket" in window) {
        ws = new MozWebSocket(url);
    } else {
        info_message("This Browser does not support WebSockets");
        return;
    }
    ws.onopen = function(e) {
        info_message("A connection to "+url+" has been opened.");
        
        $("#server_url").attr("disabled",true);
        $("#toggle_connect").html("Disconnect");
    };
    
    ws.onerror = function(e) {
        info_message("An error occured, see console log for more details.");
        console.log(e);
    };
    
    ws.onclose = function(e) {
        info_message("The connection to "+url+" was closed.");
    };
    
    ws.onmessage = function(e) {
        var message = JSON.parse(e.data);

        if(message.type == 'buf') {
            if(!audio.buffer || audio.buffer.length != message.numFrames*1)
                console.log('creating audio.buffer with size: '+message.numFrames*1);
                audio.buffer = context.createBuffer(1, message.numFrames*1, 44100);

            
            audio.buffer.getChannelData(0).set(message.samples);
        }
        
    };
}