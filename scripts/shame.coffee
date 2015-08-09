fs = require 'fs'
http = require 'http'
QS = require 'querystring'
data = ""

fs.readFile "shame.json", (err, contents) ->
  if err
    robot.logger.info "Encountered an error: #{err}"
  else
    data = contents

module.exports = (robot) ->
  robot.hear /shame/i, (msg) ->
    robot.http("https://api.particle.io/v1/devices/events")i
      .header('access_token', '#{data.access_token.toString()}'
      .header('Content-Type', 'application/x-www-form-urlencoded')
      .post(JSON.stringify(data.toString())) (err, res, body) ->
        if err
          robot.logger.info "Encountered an error: #{err}"
          return
        else
          robot.logger.info "We got back: #{body}"
    msg.send "What a true shame..."
