http = require 'http'
QS = require 'querystring'

module.exports = (robot) ->
  robot.hear /shame/i, (msg) ->
    data = JSON.stringify({
      name: "shamedingdingding",
      data: "such_shame",
      private: "false",
      ttl: 60,
      access_token: "f3498b855f461374d78e9bb4e00fea1528c9f6ab"
    })
    robot.http("https://api.particle.io/v1/devices/events")
      .header('Content-Type', 'application/json')
      .post(data) (err, res, body) ->
        if err
          robot.logger.info "Encountered an error: #{err}"
          return
        else
          robot.logger.info "We got back: #{body}"
    msg.send "What a true shame..."
