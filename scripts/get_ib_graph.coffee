# Install Base Data by GDUNS
#
# ib gduns - returns ib data if GDUN exists
#
stringTable = require('string-table')

module.exports = (robot) ->
  robot.respond /ib_graph (.*)/i, (msg) ->
    cust_name = escape(msg.match[1])
    api_url = "http://pnwreport.bellevuelab.isus.emc.com/api/graph/installs/#{cust_name}"
        
    msg.http(api_url)
      .get() (err, res, body) ->
        try
          json = JSON.parse(body)          
          msgOutput = json
          msg.send msgOutput
                    
        catch error
          msg.send error
          msg.send "Could not find gduns #{cust_name}"
