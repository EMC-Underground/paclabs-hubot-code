# Description:
#   A simple script to allow for calling back to slack to report on node status
#
# Dependencies:
#
# Configuration:
#   Can load the desired ops channel from the brain. Assign channel to 'opsChan'.
#
# Commands:
#
# Notes:
#   For node/status
#     data.user = <user>|None
#     data.status = msg
#     data.state = booted|registered|bound|installed
#     data.node-type = physical|virtual|None
#
#   Assumptions:
#     All virtual nodes will have a user
#
# Author:
#   quickjp2

module.exports = (robot) ->

  robot.router.post '/hubot/vm/complete', (req, res) ->
    data   = if req.body.payload? then JSON.parse req.body.payload else req.body
    user = data.user
    ip = data.ipaddr
    robot.send {room: user}, "You're vm is done. Please ssh into #{ip} using ubuntu/insecure."
    res.send 'OK'

  robot.router.post '/hubot/vm/status', (req, res) ->
    data = if req.body.payload? then JSON.parse req.body.payload else req.body
    status = data.status
    robot.send {room: "commander-chat"}, "#{status}"
    res.send 'OK'

  robot.router.post '/hubot/host/complete', (req, res) ->
    data   = if req.body.payload? then JSON.parse req.body.payload else req.body
    user = "commander-chat"
    text = data.text
    robot.send {room: user}, "This is a test to verify razor can send JSON. Here's what we got: #{text}"
    res.send 'OK'

  ##################################
  # Receive node status
  ##################################
  robot.router.post '/hubot/node/status', (req, res) ->
    # Load ops channel from brain or use default
    channel = robot.brain.get('opsChan') or "commander-chat"

    # Recieve data and parse any json
    data = if req.body.payload? then JSON.parse req.body.payload else req.body

    # If there is a user, send them the status update too
    if data.user isnt "None"
      robot.send {room: data.user}, "#{data.status}"

    # If a user's vm is done, don't output vm IP to ops channel, but still provide status
    if data.state is "installed" and data['node-type'] is "virtual"
      robot.send {room: channel}, "#{data.user}'s vm is has completed os install"

    # Everything else is sent straight into the ops channel
    else
      robot.send {room: channel}, "#{data.status}"
