
  /*
  #   @file       BackboneSync.coffee
  #
  #   @author     Colin Sullivan <colinsul [at] gmail.com>
  #
  #               Copyright (c) 2011 Colin Sullivan
  #               Licensed under the GPLv3 license.
  */

  Backbone.sync = function(method, model, options) {
    var message;
    message = {
      namespace: model.namespace,
      method: method,
      attributes: model.toJSON()
    };
    if (options.method) message.method = options.method;
    if (!options.nosave) tulpasynth.socket.send(message);
    return options.success();
  };
