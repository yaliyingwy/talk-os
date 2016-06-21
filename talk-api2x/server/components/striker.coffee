config = require '../../config/default'
return module.exports =
  signAuth: -> 'token'
  downloadUrl: (file)-> "#{config.fileUrl}/download/#{file.fileKey}?fileName=#{file.fileName}"
  previewUrl: (file)-> "#{config.fileUrl}/public/#{file.fileKey}"
  thumbnailUrl: (file)-> "#{config.fileUrl}/public/#{file.fileKey}"

# StrikerUtil = require 'striker-util'
# config = require 'config'

# module.exports = strikerUtil = new StrikerUtil
#   host: config.strikerHost
#   storage: config.strikerStorage
#   secretKeys: config.strikerAuth
#   expiresInSeconds: 3600 * 48
