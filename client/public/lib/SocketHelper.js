
  /*
  #   @file       SocketHelper.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  window.WebSocket = window.WebSocket || window.MozWebSocket || null;

  /*
  #   @class  A helper class to encapsulate socket connection.
  */

  tulpasynth.SocketHelper = (function() {

    /*
        #   @param  url     The URL to connect the socket to.
    */

    function SocketHelper(url) {
      this.url = url;
      this.connect();
    }

    SocketHelper.prototype.onready = function() {};

    SocketHelper.prototype.connect = function() {
      var socket;
      var _this = this;
      if (window.WebSocket === null) {
        throw new Error("This browser does not support websockets.");
        return false;
      }
      console.log("Attempting to connect to " + this.url);
      socket = new WebSocket(this.url);
      this.socket = socket;
      socket.onopen = function(e) {
        console.log('Websocket connection established.');
        return _this.onready();
      };
      socket.onerror = function(e) {
        throw new Error(e);
      };
      socket.onclose = function(e) {
        console.log('Websocket connection closed...Reconnecting...');
        return setTimeout(function() {
          return _this.connect();
        }, 500);
      };
      /*
              #   When the socket receives a synchronization message from the 
              #   server, it updates the appropriate model.
              #
              #   @param  e   Raw event object from websocket.
      */
      return socket.onmessage = function(e) {
        var id, message, method, model, modelInstance, modelType, namespaceSplit;
        message = JSON.parse(e.data);
        method = message.method;
        if (method === 'response/id') {
          id = message.id;
          model = tulpasynth.models.waitingInstances.shift();
          model.set({
            id: id
          });
          return model.save({}, {
            method: 'create'
          });
        } else {
          namespaceSplit = message.namespace.split('.');
          modelType = window;
          while (namespaceSplit.length) {
            modelType = modelType[namespaceSplit.shift()];
          }
          if (_.isUndefined(modelType)) {
            throw new Error("Type " + message.namespace + " not found.");
          }
          if (method === 'update') {
            modelInstance = Backbone.Relational.store.find(modelType, message.attributes.id);
            if (!modelInstance) {
              throw new Error("Model " + message.namespace + " id: " + message.attributes.id + " not found.");
            }
            return modelInstance.set(message.attributes);
          } else if (method === 'create') {
            return modelInstance = new modelType(message.attributes);
          } else if (method === 'delete') {
            modelInstance = Backbone.Relational.store.find(modelType, message.attributes.id);
            if (!modelInstance) {
              throw new Error("Model " + message.namespace + " id: " + message.attributes.id + " not found.");
            }
            return modelInstance.destroy({
              nosave: true
            });
          } else {
            throw new Error("Method " + method + " not recognized.");
          }
        }
      };
    };

    SocketHelper.prototype.send = function(messageObject) {
      var message;
      message = JSON.stringify(messageObject);
      console.log('Sending:');
      console.log(message);
      console.log('\n');
      return this.socket.send(message);
    };

    return SocketHelper;

  })();
