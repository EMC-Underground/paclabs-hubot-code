fs = require 'fs'
http = require 'http'
QS = require 'querystring'
data = ""

fs.readFile "shame.json", (err, contents) ->
  if err
    robot.logger.info "Encountered an error: #{err}"
  else
    data = JSON.stringify(contents.toString())

module.exports = (robot) ->
  robot.hear /shame/i, (msg) ->
    robot.http("https://api.particle.io/v1/devices/events")
      .header('Content-Type', 'application/x-www-form-urlencoded')
      .post(data) (err, res, body) ->
        if err
          robot.logger.info "Encountered an error: #{err}"
          return
        else
          robot.logger.info "We got back: #{body}"
    msg.send "What a true shame..."
