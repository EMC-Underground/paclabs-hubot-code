fs = require 'fs'
http = require 'http'
QS = require 'querystring'
data = ""

module.exports = (robot) ->
  fs.readFile 'shame.json', (err, contents) ->
    if err
      robot.logger.info "Encountered an error: #{err}"
    else
      data = JSON.stringify(contents.toString())
  robot.hear /shame/i, (msg) ->
    robot.http("https://api.particle.io/v1/devices/events")
      .header('access_token', '#{data.access_token}')
      .header('Content-Type', 'application/x-www-form-urlencoded')
      .post(data) (err, res, body) ->
        if err
          robot.logger.info "Encountered an error: #{err}"
          return
        else
          robot.logger.info "We got back: #{body}"
    msg.send "What a true shame..."

