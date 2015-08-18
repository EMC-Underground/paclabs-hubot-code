EventSource = require 'eventsource'
http = require 'http'
QS = require 'querystring'
url = require 'url'
data = ""
addr = "https://api.particle.io/v1/events" 

module.exports = (robot) ->
  eventSourceInitDict = 
    rejectUnauthorized: false
    headers: 'Authorization': 'Bearer 33d2f312a176dcc1ec87f069be6f8ef3bd0ec1cc'
  es = new EventSource(addr.toString(), eventSourceInitDict)
  es.addEventListener 'notifyr/announce', ((event) ->
    #Function code goes here
    data = JSON.parse(event.data)
    robot.logger.info "This is the data we got...#{data}"
    robot.logger.info "This is the event type...#{event.type}"
    robot.logger.info "The core ID is -#{data.coreid}- and it's data is -#{data.data}"
    robot.http("https://script.google.com/macros/s/AKfycbzD4duzxGlHqvMqlVu-apgWRE2l5GWn4tgWeJXUhMX2ivIOQHY/exec")
      .header('Content-Type', 'application/x-www-form-urlencoded')
      .post("Core_ID=#{data.coreid}&Core_Data=#{data.data}") (err, res, body) ->
        if err
          robot.logger.info "Encountered an error: #{err}"
          return
        else
          robot.logger.info "We got back success!"
    return
  ), false
