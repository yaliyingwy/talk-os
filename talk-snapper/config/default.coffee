module.exports =
  # Listening port and sockjs prefix
  port: process.env.PORT or 7003
  prefix: '/snapper/socket'
  # Configure redis pub/sub instance and channel prefix
  pub: [6379, "talk-redis"]
  sub: [6379, "talk-redis"]
  channelPrefix: 'snapper'
