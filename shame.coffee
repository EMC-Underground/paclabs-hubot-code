http = require 'http'
  QS = require 'querystring'

module.exports = (robot) ->
  robot.hear /shame/i, (msg) ->
    .post("https://api.particle.io/v1/devices/events",
           shame.json,
           function(data){console.log(data.ok)},
           json) 
    msg.send "That's a true shame..."
