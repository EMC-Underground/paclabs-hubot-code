# List of all external libraries needed
cp = require 'child_process'
fs = require 'fs'

# Prototype config object
config = {}

# Read in the json file
fs.readFile './env-vars.json', (err, contents) ->
  if err
    console.log "Encountered an error: #{err}"
  else
    console.log "We got something!"
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
    hubot = cp.spawn "./bin/hubot", ["-a","slack"], {cwd: undefined, env:process.env}
    
    hubot.stdout.on 'data', (data) -> 
      console.log('stdout: ' + data)
    console.log(hubot.pid)
    
    hubot.on "exit", ->
      process.exit()
