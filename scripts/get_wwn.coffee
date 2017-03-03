# WWN generator for EMC arrays
#
# wwn <array_type> <Serial_Number> - returns serial number table if it exists
#

module.exports = (robot) ->
  robot.respond /wwn vmax (.*)/i, (msg) ->
    array_type = escape(msg.match[1])
    serial_num = escape(msg.match[1])
    msg.send array_type
    msg.send serial_num
    msg.http("http://getwwn.bellevuelab.isus.emc.com/symmetrix/#{serial_num}")
      .get() (err, res, body) ->
        try
          json = JSON.parse(body)
          #msg.send json.wwns
          msg.send "========================================================================================================="
          msg.send "| Model: #{json.wwns[1].model}     |   Serial: #{json.wwns[1].serialnum}                                                      |"
          msg.send "========================================================================================================="
          for item in json.wwns
            #stringTable.create(item)
            msg.send "| director: #{item.director} | port: #{item.port}     | wwpn: #{item.wwpn}    | ipn: #{item.iqn}     |"
            #msg.send "   Model: #{item.model}\n
            #Serial: #{item.serialnum}\n
            #director: #{item.director}\n
            #port: #{item.port}\n
            #wwpn: #{item.wwpn}\n
            #ipn: #{item.iqn}\n"
          msg.send "========================================================================================================="
        catch error
          msg.send "Serial not found. Try another serial number"
