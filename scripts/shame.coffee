http = require 'http'
  QS = require 'querystring'

module.exports = (robot) ->
  robot.hear /shame/i, (msg) ->
    msg.http("https://api.particle.io/v1/devices/events").post(shame.json) (err, res, body) ->
      if err
        msg.logger.info "Encountered an error: #{err}"
        return
      else
        msg.logger.info "We got back: #{body}"
    msg.send "That's a true shame..."
