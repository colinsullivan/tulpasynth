var url = 'ws://localhost:9003/sound';
var ws = null;

function connect() {
    console.log('Connecting to: '+url);
    
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
        
        if (message.type == "msg") {
            info_message(message.value,message.sender);
        } else if (message.type == "participants") {
            var o = "<ul>";
            for (var p in message.value) {
                o += "<li>"+message.value[p]+"</li>";
            }
            o += "</ul>";
            $("#participants").html(o);
        }
    };
}