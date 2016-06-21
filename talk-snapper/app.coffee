logger = require('graceful-logger').format 'medium'
config = require './config/default'
app = require('http').createServer()
server = app.listen config.port, -> logger.info "Talk listen on #{config.port}"
snapperInitializer = require './server/server'
snapperInitializer server
logger.info 'Snapper initialized'