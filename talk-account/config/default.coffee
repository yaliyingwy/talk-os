countries = require './util/countries'

module.exports =
  env: 'static'
  debug: true
  cdn: '/account'
  isMinified: no
  webpackDevPort: 8011
  useCDN: no
  checkToken: 'Check token for heartbeat'
  resourceDomain: 'http://talk-web.xegood.com'
  useAnalytics: no
  # URL
  accountUrl: 'http://talk-web.xegood.com/account'
  siteUrl: 'http://talk-web.xegood.com'
  weiboLogin: "http://talk-web.xegood.com/account/union/weibo?method=bind&next_url=#{encodeURIComponent 'http://talk-web.xegood.com/v2/weibo/landing'}",
  firimLogin: "http://talk-web.xegood.com/account/union/firim?method=bind&next_url=#{encodeURIComponent 'http://talk-web.xegood.com/v2/firim/landing'}",
  githubLogin: "http://talk-web.xegood.com/account/union/github?method=bind&service=talk&nologin=1&next_url=#{encodeURIComponent 'http://talk-web.xegood.com/v2/github/landing'}",
  trelloLogin: "http://talk-web.xegood.com/account/union/trello?method=bind&next_url=#{encodeURIComponent 'http://talk-web.xegood.com/v2/trello/landing'}",
  teambitionLogin: "http://talk-web.xegood.com/account/union/teambition?method=bind&next_url=#{encodeURIComponent 'http://talk-web.xegood.com/v2/teambtion/landing'}",
  # Cookies
  cookieDomain: '.talk-web.xegood.com'
  accountCookieId: 'aid'
  accountCookieSecret: 'Cookie secret of account'
  accountCookieExpires: 2592000
  # Connections
  mongo:
    address: 'mongodb://talk-mongo:27017/talk_account'
  redis:
    host: 'talk-redis'
  # Client
  client:
    countries: countries
