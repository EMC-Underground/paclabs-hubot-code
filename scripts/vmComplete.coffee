# Description:
#   A simple script to allow for calling back to a user upon completion of a vm
#
# Dependencies:
#
# Configuration:
#
# Commands:
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   quickjp2

module.exports = (robot) ->
  # 
  robot.router.post '/hubot/vm/complete', (req, res) ->

    data   = if req.body.payload? then JSON.parse req.body.payload else req.body
    user = data.user
    ip = data.ipaddr
    

    robot.send {room: user}, "You're vm is done. Please ssh into #{ip} using your netid."

    res.send 'OK'
