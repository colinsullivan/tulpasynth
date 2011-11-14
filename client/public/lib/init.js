(function() {
  var ws;

  window.WebSocket = window.WebSocket || window.MozWebSocket || null;

  ws = null;

  $(document).ready(function() {
    if (window.WebSocket === null) {
      throw new Error("This browser does not support websockets.");
    } else {
      return ws = new WebSocket('ws://localhost:9003/socket');
    }
  });

}).call(this);
