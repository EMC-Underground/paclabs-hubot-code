module.exports = (robot) ->
  robot.respond /(white paper|whitepaper)( me)? (.*)/i, (msg) ->
    whitepaperMe msg, msg.match[2], (url) ->
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
      searchType:'image',
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
          image = msg.random response.items
          cb ensureImageExtension image.link
        else
          msg.send "Oops. I had trouble searching '#{query}'. Try later."
          ((error) ->
            msg.robot.logger.error error.message
            msg.robot.logger
              .error "(see #{error.extendedHelp})" if error.extendedHelp
          ) error for error in response.error.errors if response.error?.errors
  else
    msg.robot.logger.error "Missing environment variable HUBOT_GOOGLE_CSE_ID"
    msg.send "Missing server environment variable HUBOT_GOOGLE_CSE_ID."
    return
