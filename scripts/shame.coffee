fs = require 'fs'
http = require 'http'
QS = require 'querystring'
data = ""

module.exports = (robot) ->
  fs.readFile '/app/scripts/config.txt', (err, contents) ->
    if err
      robot.logger.info "Encountered an error: #{err}"
    else
      data = contents.toString()
  robot.hear /shame/i, (msg) ->
    robot.logger.info "Data is: #{data}"
    robot.http("https://api.particle.io/v1/devices/events")
      .header('Content-Type': 'application/x-www-form-urlencoded')
      .post(encodeURIComponent(data)) (err, res, body) ->
        if err
          robot.logger.info "Encountered an error: #{err}"
          return
        else
          robot.logger.info "We got back: #{body}"
    msg.send "What a true shame..."

