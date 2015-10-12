# Description:
#
# Dependencies:
#
# Configuration:
#
# Commands:
#
# Notes:
#
# Author:
#   quickjp2



EventSource = require 'eventsource'
http = require 'http'
QS = require 'querystring'
url = require 'url'
fs = require 'fs'
es_config = {}
data = "" 
token = es_config['auth-token']

fs.readFile './es-config.json', (err, contents) ->
  if err
    console.log "Encountered an error: #{err}"
  else
    es_config = JSON.parse(contents.toString())

addr = es_config['particle-url']

module.exports = (robot) ->
  eventSourceInitDict = 
    rejectUnauthorized: false
    headers: 'Authorization': 'Bearer #{token}'
  es = new EventSource("#{addr}", eventSourceInitDict)
  es.addEventListener 'notifyr/announce', ((event) ->
    #Function code goes here
    data = JSON.parse(event.data)
    robot.logger.info "This is the data we got...#{data}"
    robot.logger.info "This is the event type...#{event.type}"
    robot.logger.info "The core ID is -#{data.coreid}- and it's data is -#{data.data}"
    robot.http(es_config['google-sheet-url'])
      .header('Content-Type', 'application/x-www-form-urlencoded')
      .post("Core_ID=#{data.coreid}&Core_Data=#{data.data}") (err, res, body) ->
        if err
          robot.logger.info "Encountered an error: #{err}"
          return
        else
          robot.logger.info "We got back success!"
    return
  ), false
