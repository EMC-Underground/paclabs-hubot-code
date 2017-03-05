# WWN generator for EMC arrays
#
# wwn <array_type> <Serial_Number> - returns serial number table if it exists
#
stringTable = require('string-table')

module.exports = (robot) ->
  robot.respond /wwn (.*) (.*)/i, (msg) ->
    array_type = escape(msg.match[1])
    serial_num = escape(msg.match[2])
    
    switch array_type
        when "vmax", "VMAX", "symmetrix", "symm", "Symmetrix" 
            array_type = "symmetrix"
            api_url = "http://getwwn.bellevuelab.isus.emc.com/#{array_type}/#{serial_num}"
            break_line = "============================================================================="
            tbl_format = {headerSeparator: '=', headers: ['director', 'port', 'wwpn', 'iqn']}
            
        when "xtremio", "XTremIO", "xio", "XIO" 
            array_type = "xtremio"
            num_bricks = "8"
            api_url = "http://getwwn.bellevuelab.isus.emc.com/#{array_type}/#{serial_num}/#{num_bricks}"             
            break_line = "=========================================================================================================="
            tbl_format = {headerSeparator: '=', headers: ['brick', 'controller', 'port', 'wwpn', 'iqn']}

    msg.http(api_url)
      .get() (err, res, body) ->
        try
          json = JSON.parse(body)          
          msgOutput = "\n" + break_line + "\n"
          msgOutput = msgOutput + "| Model: #{json.wwns[1].model}     |   Serial: #{serial_num}               \n"
          msgOutput = msgOutput + break_line
          msgOutput = msgOutput + "\n"
          msgOutput = msgOutput + stringTable.create(json.wwns, tbl_format) + "\n"
          msgOutput = msgOutput + break_line + "\n"
          msg.send msgOutput
                    
        catch error
          msg.send error
          msg.send "Serial not found. Try another serial number"
