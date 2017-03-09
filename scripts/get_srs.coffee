# List all SRS for a GDUNS
#
# srs gduns - returns all srs for this customer
#
stringTable = require('string-table')

module.exports = (robot) ->
  robot.respond /srs (.*)/i, (msg) ->
    cust_name = escape(msg.match[1])
    api_url = "http://pnwreport.bellevuelab.isus.emc.com/api/srs/#{cust_name}"
    break_line = "============================================================================="
    tbl_format = {headerSeparator: '=', headers: ['PARTY_NAME', 'PARTY_NUMBER', 'SR', 'SR_STATUS', 'SEV', 'SERIAL_NUMBER', 'PRODUCT_DESCRIPTION']}
            
    
    msg.http(api_url)
      .get() (err, res, body) ->
        try
          json = JSON.parse(body)          
          msgOutput = "\n" + break_line + "\n"
          #msgOutput = msgOutput + "| GDUNS Name: #{json[1].["Global Duns Name"]}     |   Serial: #{serial_num}               \n"
          #msgOutput = msgOutput + break_line
          #msgOutput = msgOutput + "\n"
          msgOutput = msgOutput + stringTable.create(json.rows, tbl_format) + "\n"
          msgOutput = msgOutput + break_line + "\n"
          msg.send msgOutput
                    
        catch error
          msg.send error
          msg.send "Could not find gduns #{cust_name}"
