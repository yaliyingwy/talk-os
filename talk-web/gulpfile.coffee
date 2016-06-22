
fs = require 'fs'
path = require 'path'
gulp = require 'gulp'
gutil = require 'gulp-util'
config = require 'config'
webpack = require 'webpack'
sequence = require 'run-sequence'
WebpackDevServer = require 'webpack-dev-server'
shell = require('gulp-shell')

env = process.env.NODE_ENV

debug = true

gulp.task 'html', (cb) ->
  template = require './entry/template'
  assetLinks = require './packing/asset-links'

  html = template(assetLinks, config)
  fs.writeFile 'build/index.html', html, cb

gulp.task 'clean', (cb) ->
  del = require 'del'

  del ['build'], cb

gulp.task('serve', shell.task('ps -ef |grep "node app.js"|grep -Ev "grep"|awk \'{print $2}\'|xargs kill -9 && node app.js'));

# Webpack tasks

gulp.task 'webpack-dev', (cb) ->

  webpackServer =
    contentBase: 'build'
    historyApiFallback: true
    hot: true
    stats:
      colors: true
    proxy: {'/v2*': 'http://talk-web.xegood.com'}
  info =
    debug: true
  webpackDev = require('./packing/webpack-config')(info)

  compiler = webpack (webpackDev)
  server = new WebpackDevServer compiler, webpackServer

  server.listen 8080, 'localhost', (err) ->
    if err?
      throw new gutil.PluginError("webpack-dev-server", err)
    gutil.log "[webpack-dev-server] is listening"
    cb()

gulp.task 'webpack-build', (cb) ->
  webpackBuild = require './packing/webpack-config'
  info =
    debug: debug
  webpack (webpackBuild info), (err, stats) ->
    if err
      throw new gutil.PluginError("webpack", err)
    gutil.log '[webpack]', stats.toString()
    fileContent = JSON.stringify stats.toJson().assetsByChunkName
    fs.writeFileSync 'packing/assets.json', fileContent
    cb()

gulp.task 'webpack-test', (cb) ->
  config = require './test/pages/webpack'
  webpackServer =
    publicPath: '/'
    hot: true
    stats:
      colors: true
  compiler = webpack config
  server = new WebpackDevServer compiler, webpackServer

  server.listen 9000, 'localhost', (err) ->
    if err?
      throw new gutil.PluginError("webpack-dev-server", err)
    gutil.log "[webpack-dev-server] is listening"
    cb()

# aliases

gulp.task 'dev', (cb) ->
  debug = true
  gutil.log gutil.colors.yellow("Running Gulp in `#{process.env.MODEL}` mode!")
  sequence 'html', 'webpack-dev', cb

gulp.task 'build', (cb) ->
  debug = true
  gutil.log gutil.colors.yellow("Running Gulp in `#{process.env.MODEL}` mode!")
  sequence 'clean', 'webpack-build', 'html', cb

gulp.task 'dist', (cb) ->
  debug = false
  gutil.log gutil.colors.yellow("Running Gulp in `#{process.env.MODEL}` mode!")
  sequence 'clean', 'webpack-build', 'html', cb

# CDN

gulp.task 'cdn', (cb) ->
  filelog = require 'gulp-filelog'
  upyunDest = require('gulp-upyun').upyunDest

  configFile = path.join __dirname, 'upyun-config.coffee'
  unless fs.existsSync(configFile)
    gutil.log gutil.colors.red("Error: Need upyun config file!")
    process.exit(1)
  options = require './upyun-config'
  gulp.src('build/**/*')
  .pipe filelog('Uploading to Upyun')
  .pipe upyunDest('dn-st/talk-web', options)
  .on 'error', gutil.log

# coffeelint

gulp.task 'lint', ->
  coffeelint = require 'gulp-coffeelint'
  gulpFilter = require 'gulp-filter'

  filter = gulpFilter ['**', '!**/en.coffee', '!**/zh.coffee', '!**/zh-tw.coffee',
    "!**/module/icons.coffee"
  ]

  gulp.src('./client/**/*.coffee')
  .pipe filter
  .pipe coffeelint
    max_line_length: {value: 160}
    arrow_spacing: {level: 'warn'}
    eol_last: {level: 'warn'}
    no_empty_param_list: {level: 'warn'}
    no_interpolation_in_single_quotes: {level: 'warn'}
  .pipe coffeelint.reporter()
  .pipe coffeelint.reporter('failOnWarning')
