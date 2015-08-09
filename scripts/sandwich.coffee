module.exports = (robot) ->
  robot.hear /sandwich/i, (msg) ->
    msg.send "Did someone say sandwich?"
