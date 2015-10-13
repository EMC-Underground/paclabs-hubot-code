# List of all external libraries needed
spawn = require('child_process').spawn
fs = require 'fs'
config = {}

# Read in the json file
fs.readFile './env-vars.json', (err, contents) ->
  if err
    console.log "Encountered an error: #{err}"
  else
    config = JSON.parse(contents.toString())

# Specify the environment variables
if Object.keys(config).length == 0
  # config is "empty"
  console.log "No environment variables found..."
else
  # myObject is not "empty"
  for key,value of config
    console.log key + " is " + value
    process.env["#{key}"] = value

# Start hubot
hubot = spawn "./bin/hubot", ["-a","slack"], {cwd: undefined, env:process.env}

hubot.on "exit", ->
  process.exit()


