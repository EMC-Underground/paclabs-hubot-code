# Description:
#    Allows you to 'shame' people in chat
#
# Dependencies:
#    NONE
#
# Configuration:
#    NONE
#
# Commands:
#    shame - shames
#
# Notes:
#    This only sends an event to the particle cloud. For full 'shaming' capabilities, please see https://github.com/bkvarda/cersei.
#
# Author:
#   quickjp2

(($) ->) 'jquery'
fs = require 'fs'
http = require 'http'
QS = require 'querystring'
data = ""

module.exports = (robot) ->
  fs.readFile './scripts/config.txt', (err, contents) ->
    if err
      robot.logger.info "Encountered an error: #{err}"
    else
      data = contents.toString()
  robot.hear /shame/i, (msg) ->
    data = "name=shamedingdingding&data=#{msg.message.user.name} made me shame" 
    robot.logger.info "Data is: #{data}"
    robot.http("https://api.particle.io/v1/devices/events/")
      .header('Authorization', 'Bearer 33d2f312a176dcc1ec87f069be6f8ef3bd0ec1cc')
      .header('Content-Type', 'application/x-www-form-urlencoded')
      .post(data) (err, res, body) ->
        if err
          robot.logger.info "Encountered an error: #{err}"
          return
        else
          robot.logger.info "We got back: #{body}"
    # Send a message to the chat client
    msg.send "What a true shame..."

