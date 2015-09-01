fs = require 'fs'
http = require 'http'
qs = require 'querystring'

module.exports = (robot) ->
  robot.hear /getToken/i, (msg) ->
    unless robot.auth.isAdmin msg.message.user
      msg.reply "Sorry, only admins can refresh the token."
    else
      robot.http("https://vcac.bellevue.lab/api/tokens")
        .header('Accept', 'application/json')
        .header('Content-Type', 'application/json')
        .post("{"username":"administrator@vshpere.local","password":"Iamadmin!","tenant":"vshpere.local"}")(err, res, body) ->
          if err
            robot.logger.info "Encountered an error: #{err}"
            return
          else
            robot.logger.info "We got back: #{body}"
            fs.writeFile "./scripts/authToken.json", JSON.stringify(body), (error) ->
              if error
                robot.logger.info "Encounterd an error: #{error}"

