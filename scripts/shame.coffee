(($) ->) 'jquery'
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
  robot.respond /shame/i, (msg) ->
    data = "name=shamedingdingding&data=#{msg.message.user.name}_made_me_shame" 
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

# jquery ajax
#   $.ajax
#     url: 'https://api.particle.io/v1/devices/events/'
#     type: 'post'
#     data:
#       name: 'shamedingdingding'
#       data: 'This is commander bot'
#     headers: Authorization: 'Bearer 33d2f312a176dcc1ec87f069be6f8ef3bd0ec1cc'
#     dataType: 'x-www-form-urlencoded'
#     success: (data) ->
#       console.info data

# Send a message to the chat client
    msg.send "What a true shame..."

