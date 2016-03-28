# Description:
#    Handles talking to the EMC Dashboard
#
# Dependencies:
#    NONE
#
# Configuration:
#    NONE
#
# Commands:
#    hubot display me <gdun | name> - sets the next dashboard to desired customer
#
# Notes:
#
# Author:
#   quickjp2

fs = require 'fs'
http = require 'http'
QS = require 'querystring'

module.exports = (robot) ->
  robot.respond /display(\sme)?\s(.*)/i, (msg) ->
    account = msg.match[2]
    data = { gdun: account}
    robot.http("http://dashupdater.bellevuelab.isus.emc.com/dashboard/")
      .header('Content-Type', 'application/json')
      .put(JSON.stringify(data)) (err, res, body) ->
        if err
          robot.logger.info "Encountered an error: #{err}"
          return
        else
          robot.logger.info "We got back: #{body}"
          msg.send body


