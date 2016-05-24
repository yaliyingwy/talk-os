countries = require './util/countries'

module.exports =
  env: 'static'
  debug: true
  cdn: '/account'
  isMinified: no
  webpackDevPort: 8011
  useCDN: no
  checkToken: 'Check token for heartbeat'
  resourceDomain: 'http://talk-web:7001/account'
  useAnalytics: no
  # URL
  accountUrl: 'http://talk-web:7001/account'
  siteUrl: 'http://talk-web:7001'
  weiboLogin: "http://talk-web:7001/account/union/weibo?method=bind&next_url=#{encodeURIComponent 'http://talk-web:7001/v2/weibo/landing'}",
  firimLogin: "http://talk-web:7001/account/union/firim?method=bind&next_url=#{encodeURIComponent 'http://talk-web:7001/v2/firim/landing'}",
  githubLogin: "http://talk-web:7001/account/union/github?method=bind&service=talk&nologin=1&next_url=#{encodeURIComponent 'http://talk-web:7001/v2/github/landing'}",
  trelloLogin: "http://talk-web:7001/account/union/trello?method=bind&next_url=#{encodeURIComponent 'http://talk-web:7001/v2/trello/landing'}",
  teambitionLogin: "http://talk-web:7001/account/union/teambition?method=bind&next_url=#{encodeURIComponent 'http://talk-web:7001/v2/teambtion/landing'}",
  # Cookies
  cookieDomain: '.talk-web'
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
