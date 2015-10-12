# Description:
#    Similar functionallity to image me, this instead searches for papers and websites on the topic
#
# Dependencies:
#    "hubot-google-images":"^0.1.5"
#
# Configuration:
#    NONE
#
# Commands:
#    hubot whitepaper me <query> - Searches for the query
#
# Notes:
#
# Author:
#   quickjp2

module.exports = (robot) ->
  robot.respond /(white paper|whitepaper)( me)? (.*)/i, (msg) ->
    whitepaperMe msg, msg.match[3], (url) ->
      msg.send url


whitepaperMe = (msg, query, cb) ->
  googleCseId = process.env.HUBOT_GOOGLE_CSE_ID
  if googleCseId
    # Using Google Custom Search API
    googleApiKey = process.env.HUBOT_GOOGLE_CSE_KEY
    if !googleApiKey
      msg.robot.logger.error "Missing environment variable HUBOT_GOOGLE_CSE_KEY"
      msg.send "Missing server environment variable HUBOT_GOOGLE_CSE_KEY."
      return
    q =
      q: query,
      searchType:'web',
      safe:'high',
      fields:'items(link)',
      cx: googleCseId,
      key: googleApiKey
    url = 'https://www.googleapis.com/customsearch/v1'
    msg.http(url)
      .query(q)
      .get() (err, res, body) ->
        if err
          msg.send "Encountered an error :( #{err}"
          return
        if res.statusCode isnt 200
          msg.send "Bad HTTP response :( #{res.statusCode}"
          return
        response = JSON.parse(body)
        if response?.items
          image = response.items[1]
        else
          msg.send "Oops. I had trouble searching '#{query}'. Try later."
          ((error) ->
            msg.robot.logger.error error.message
            msg.robot.logger
              .error "(see #{error.extendedHelp})" if error.extendedHelp
          ) error for error in response.error.errors if response.error?.errors
  else
    # Using deprecated Google image search API
    msg.send "You are searching for #{query}..."
    q = v: '1.0', q: query, safe: 'active'
    msg.http('https://ajax.googleapis.com/ajax/services/search/web')
      .query(q)
      .get() (err, res, body) ->
        if err
          msg.send "Encountered an error :( #{err}"
          return
        if res.statusCode isnt 200
          msg.send "Bad HTTP response :( #{res.statusCode}"
          return
        images = JSON.parse(body)
        images = images.responseData?.results
        if images?.length > 0
          image = images[1]
          msg.send "...here we go: #{image.titleNoFormatting}"
          msg.send "URL: #{image.unescapedUrl}" 
        else
          msg.send "Sorry, I found no results for '#{query}'."
