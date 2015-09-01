
module.exports = (robot) ->
  robot.respond /token/i, (msg) ->
    robot.http("https://vcac.bellevue.lab/api/tokens")
      .header('Content-Type', 'application/json')
      .post("{"username":"administrator@vshpere.local","password":"Iamadmin!","tenant":"vshpere.local"}") (err, res, body) ->
        if err
          robot.logger.info "Encountered an error: #{err}"
          return
        else
          robot.logger.info "We got back: #{body}"
          fs.writeFile "./scripts/authToken.json", JSON.stringify(body), (error) ->
            if error
              robot.logger.info "Encounterd an error: #{error}"
