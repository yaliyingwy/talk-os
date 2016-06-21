server = require './server/server'
logger = require('graceful-logger').format 'medium'

port = process.env.PORT or 7000
server.listen port, -> logger.info "Server listen on #{port}"
