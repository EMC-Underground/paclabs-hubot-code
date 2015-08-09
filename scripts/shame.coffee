http = require 'http'
  QS = require 'querystring'

module.exports = (robot) ->
  robot.hear /shame/i, (msg) ->
    msg.http("https://api.particle.io/v1/devices/events").post(shame.json) (err, res, body) ->
      if err
        res.send "Encountered an error: #{err}"
        return
      else
        res.send "We got back: #{body}"

