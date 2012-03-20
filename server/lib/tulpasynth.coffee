###
#   @file       tulpasynth.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2012 Colin Sullivan
#               Licensed under the MIT license.
###

exports.models = {

    ###
    #   Retrieve the next ID from the database.
    ###
    next_id: (db, cb) ->
        db.get "next_id", (err, nextId) =>
            if err
                throw err

            # Increment next id
            db.incr("next_id")

            cb nextId


}
# Model instances keyed by id
exports.modelInstances = {}