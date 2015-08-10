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
    robot.http("https://api.particle.io/v1/devices/events/")
      .header('Authorization', 'Bearer 33d2f312a176dcc1ec87f069be6f8ef3bd0ec1cc')
      .header('Content-Type', 'application/json')
      .post(data) (err, res, body) ->
        if err
          robot.logger.info "Encountered an error: #{err}"
          return
        else
          robot.logger.info "We got back: #{body}"
    msg.send "What a true shame..."

