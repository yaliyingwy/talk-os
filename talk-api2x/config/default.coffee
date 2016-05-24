path = require 'path'

module.exports = config =
  debug: true
  apiHost: 'talk-web:7001'
  accountId: 'aid'
  apiVersion: 'v2'
  webHost: 'talk-web:7001'
  sessionDomain: '.talk-web'
  guestHost: 'talk-web:7001'
  schema: 'http'
  mongodb: 'mongodb://talk-mongo:27017/talk'
  redisHost: 'talk-redis'
  redisPort: 6379
  redisDb: 0
  snapper:
    pub: [6379, 'talk-redis']
    clientId: 'Client id of snapper'
    clientSecret: 'Client secret of snapper'
    channelPrefix: 'snapper'
    host: 'talk-web:7001/snapper'  # For test
  talkAccountApiUrl: 'http://talk-web:7001/account'
  talkAccountPageUrl: 'http://talk-web:7001/page'
  cdnPrefix: 'https://dn-talk.oss.aliyuncs.com'
  checkToken: 'Check token for heartbeat statement'
  serviceConfig:
    apiHost: 'http://talk-web:7001/v2'
    cdnPrefix: "http://talk-web:7001/v2/services-static"
    talkAccountApiUrl: 'http://talk-web:7001/account'
    teambition:
      clientSecret: 'Your teambition application secret'
      host: 'https://www.teambition.com'
    rss:
      serviceUrl: 'http://talk-web:7411'
    github:
      apiHost: 'https://api.github.com'
    talkai:
      apikey: "Api key of talkai"
      devid: "Devid of talkai"
    trello:
      apiKey: 'Api key of trello'
    serviceTokens:
      weibo: 'Service token of weibo'
      rss: 'Service token of rss'
