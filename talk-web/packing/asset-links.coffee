assets = require '../packing/assets'
prefix = '/'

assetLinks =
  main: "#{prefix}#{assets.main[0]}"
  style: "#{prefix}#{assets.main[1]}"
  vendor: "#{prefix}#{assets.vendor}"

module.exports = assetLinks
