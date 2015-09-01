
module.exports = (robot) ->
  robot.respond /token/i, (msg) ->
    robot.http("https://vcac.bellevue.lab/api/tokens")
