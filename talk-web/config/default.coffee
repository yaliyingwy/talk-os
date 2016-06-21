
isGuest = process.env.APP is 'guest'

module.exports =
  env: 'static',
  isGuest: isGuest
  version: require('../package.json').version
  apiHost: if isGuest then '/api' else '/v2'
  sockHost: 'http://talk-web.xegood.com/snapper',
  inteUrl: 'http://account.project.ci',
  accountUrl: 'http://talk-web.xegood.com/account',
  domainUrl: 'http://talk-web.xegood.com',
  uploadUrl: 'http://talk-web.xegood.com/files',
  cookieDomain: '.talk-web.xegood.com'
  pdfStaticHost: 'http://dn-static.oss.aliyuncs.com/pdf-viewer/v0.3.0/index.html',
  loginUrl: 'http://talk-web.xegood.com/account',
  logoutUrl: 'http://talk-web.xegood.com/account',
  weiboLogin: "http://talk-web.xegood.com/account/union/weibo?method=bind&next_url=#{encodeURIComponent 'http://talk-web.xegood.com/v2/union/weibo/landing'}",
  firimLogin: "http://talk-web.xegood.com/account/union/firim?method=bind&next_url=#{encodeURIComponent 'http://talk-web.xegood.com/v2/union/firim/landing'}",
  githubLogin: "http://talk-web.xegood.com/account/union/github?method=bind&service=talk&nologin=1&next_url=#{encodeURIComponent 'http://talk-web.xegood.com/v2/union/github/landing'}",
  trelloLogin: "http://talk-web.xegood.com/account/union/trello?method=bind&next_url=#{encodeURIComponent 'http://talk-web.xegood.com/v2/union/trello/landing'}",
  teambitionLogin: "http://talk-web.xegood.com/account/union/teambition?method=bind&next_url=#{encodeURIComponent 'http://talk-web.xegood.com/v2/union/teambtion/landing'}",
  feedbackUrl: 'http://talk-web.xegood.com/v2/services/webhook/4d76d92134e727620fce35d7d7c5b1c43921101e'
  windowOnErrorUrl: 'http://talk-web.xegood.com/v2/services/webhook/14b30bc73f75044e7500721dee5e985e58049382'
  webpackDevPort: 8081,
  cdn: 'https://dn-st.b0.upaiyun.com'
  isMinified: no
  isProduction: no # whether to add NODE_ENV=production duration packing
  useAnalytics: no
  useCDN: no
  serverEnv: 'dev'
