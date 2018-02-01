# Get SiteID and GDUNS by customer name
#
# siteid Customer_Name returns customer sites by name
#
stringTable = require('string-table')

module.exports = (robot) ->
  robot.respond /siteid (.*)/i, (msg) ->
    cust_name = escape(msg.match[1])
    api_url = "http://pnwreport.pcf.paclabs.se.lab.emc.com/api/gdun/#{cust_name}"
    break_line = "============================================================================="
    tbl_format = {headerSeparator: '=', headers: ['CS Customer Name', 'City', 'State', 'Party Number', 'Global Duns Number', 'Total Box Count', 'Open SRs']}
            
    
    msg.http(api_url)
      .get() (err, res, body) ->
        try
          json = JSON.parse(body)          
          msgOutput = "'\n" + break_line + "\n"
          #msgOutput = msgOutput + "| GDUNS Name: #{json[1].["Global Duns Name"]}     |   Placeholder               \n"
          #msgOutput = msgOutput + break_line
          #msgOutput = msgOutput + "\n"
          msgOutput = msgOutput + stringTable.create(json, tbl_format) + "\n"
          msgOutput = msgOutput + break_line + "\n'"
          msg.send msgOutput
                    
        catch error
          msg.send error
          msg.send "#{cust_name} can not be found!"
