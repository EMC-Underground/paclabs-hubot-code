# Install Base Data by GDUNS
#
# ib gduns - returns ib data if GDUN exists
#
stringTable = require('string-table')

module.exports = (robot) ->
  robot.respond /ib (.*)/i, (msg) ->
    cust_name = escape(msg.match[1])
    api_url = "http://pnwreport.bellevuelab.isus.emc.com/api/installs/#{cust_name}"
    break_line = "============================================================================="
    tbl_format = {headerSeparator: '=', headers: ['CS_CUSTOMER_NAME', 'PRODUCT_GROUP', 'ITEM_SERIAL_NUMBER', 'SALES_ORDER', 'CONTRACT_SUBLINE_END_DATE']}
            
    
    msg.http(api_url)
      .get() (err, res, body) ->
        try
          json = JSON.parse(body)          
          msgOutput = "\n" + break_line + "\n"
          #msgOutput = msgOutput + "| CS Name: #{json[1].["CS_CUSTOMER_NAME"]}     |   GDUNS: #{cust_name}               \n"
          #msgOutput = msgOutput + break_line
          #msgOutput = msgOutput + "\n"
          msgOutput = msgOutput + stringTable.create(json.rows, tbl_format) + "\n"
          msgOutput = msgOutput + break_line + "\n"
          msg.send msgOutput
                    
        catch error
          msg.send error
          msg.send "Could not find gduns #{cust_name}"
