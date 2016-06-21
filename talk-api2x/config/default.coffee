path = require 'path'

module.exports = config =
  searchHost: 'talk-search'
  searchPort: 9200
  searchProtocol: 'http'

  debug: true
  fileUrl: 'http://talk-web.xegood.com'
  apiHost: 'talk-web.xegood.com'
  accountId: 'aid'
  apiVersion: 'v2'
  webHost: 'talk-web.xegood.com'
  sessionDomain: '.talk-web.xegood.com'
  guestHost: 'talk-web.xegood.com'
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
    host: 'talk-web.xegood.com/snapper'  # For test
  talkAccountApiUrl: 'http://talk-account:7000'
  talkAccountPageUrl: 'http://talk-account:7000/page'
  cdnPrefix: 'https://dn-talk.oss.aliyuncs.com'
  checkToken: 'Check token for heartbeat statement'
  serviceConfig:
    apiHost: 'http://talk-web.xegood.com/v2'
    cdnPrefix: "http://talk-web.xegood.com/v2/services-static"
    talkAccountApiUrl: 'http://talk-account.xegood.com:7004/account'
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
