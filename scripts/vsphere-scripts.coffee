fs = require 'fs'
http = require 'http'
process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0"

module.exports = (robot) ->
  robot.respond /token/i, (msg) ->
    data = {"username":"administrator@vsphere.local","password":"Iamadmin!","tenant":"vsphere.local"}
    robot.http("https://vcac.bellevue.lab/identity/api/tokens")
      .header('Content-Type', 'application/json')
      .post(JSON.stringify(data)) (err, res, body) ->
        if err
          robot.logger.info "Encountered an error: #{err}"
          return
        else
          robot.logger.info "We got back: #{body}"
          fs.writeFile "./scripts/authToken.json", JSON.parse(body), (error) ->
            if error
              robot.logger.info "Encounterd an error: #{error}"

  robot.respond /status/i, (msg) ->
    fs.readFile './scripts/authToken.json', (err, data) ->
      if err
        robot.logger.info "Encountered an error: #{err}"
      else
        authToken = data.id
    robot.logger.info "We have this id: #{authToken}"

