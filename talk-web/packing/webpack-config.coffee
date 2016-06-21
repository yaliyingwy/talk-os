fs = require('fs')
path = require('path')
webpack = require('webpack')
autoprefixer = require 'autoprefixer'

imageName = 'images/[name].[ext]'
fontName = 'fonts/[name].[ext]'
SkipPlugin = require 'skip-webpack-plugin'
cssnano = require 'cssnano'
ExtractTextPlugin = require('extract-text-webpack-plugin')

module.exports = (info) ->
  console.log 'info:', info
  if info.app is 'guest'
    main = './client/guest/main.coffee'
  else
    main = './client/main.coffee'

  if info.debug
    hotEntry = ['webpack-dev-server/client?http://localhost:8080', 'webpack/hot/dev-server']
    fileName = '[name]'
  else
    hotEntry = []
    fileName = '[name].[chunkhash:8]'
  
  
  # returns
  entry: {
    main: hotEntry.concat([main]),
    vendor: hotEntry.concat([
      './client/vendor/primus'
      'actions-recorder', 'base-64', 'classnames', 'cookie_js', 'debounce'
      'favico.js', 'fileapi', 'filesize', 'highlight.js/lib/highlight'
      'immutable', 'keycode', 'lodash.isequal', 'lodash.ismatch', 'lodash.uniq'
      'markdown-it', 'markdown-it-attrs', 'markdown-it-emoji', 'moment', 'object-assign'
      'pinyin', 'q', 'qrcode-generator', 'react'
      'react-addons-css-transition-group', 'react-addons-linked-state-mixin'
      'react-addons-pure-render-mixin', 'react-addons-transition-group'
      'react-dom', 'react-textarea-autosize'
      'reqwest', 'router-view', 'shortid', 'smoothscroll-polyfill'
      'talk-msg-dsl', 'tether-drop', 'tether-shepherd'
      'type-of', 'utf8', 'wolfy87-eventemitter', 'xss'
    ])
  },
  debug: info.debug,
  devtool: 'cheap-module-inline-source-map',
  errorDetails: true
  delay: 50,
  output: {
    path: path.join __dirname, '..', 'build' # build/ at project root
    publicPath: "/",
    filename: "js/#{fileName}.js"
  },
  module: {
    loaders: [
      {test: /\.coffee$/, loaders: ['react-hot-loader', 'coffee-jsx-loader'], exclude: /node_modules/},
      {test: /\.cjsx$/, loaders: ['react-hot-loader', 'coffee-jsx-loader'], exclude: /node_modules/},
      {test: /\.jsx$/, loaders: ['react-hot-loader', 'babel-loader?presets[]=react,presets[]=es2015,presets[]=stage-0']},
      {test: /\.less$/, loader: ExtractTextPlugin.extract('style-loader', 'css!postcss!less')},
      {test: /\.css$/, loader: ExtractTextPlugin.extract('style-loader', 'css!postcss')},
      {test: /\.json$/, loader: 'json'},
      {test: require.resolve('jquery'), loader: 'expose?jQuery'},
      {test: /\.(png|jpg|gif)$/, loader: 'url', query: {limit: 2048, name: imageName}},
      {test: /\.woff(\?\S*)?$/, loader: "url", query: {limit: 100, mimetype: 'application/font-woff', name: fontName}},
      {test: /\.woff2(\?\S*)?$/, loader: "url", query: {limit: 100, mimetype: 'application/font-woff2', name: fontName}},
      {test: /\.ttf(\?\S*)?$/, loader: "url", query: {limit: 100, mimetype: "application/octet-stream", name: fontName}},
      {test: /\.eot(\?\S*)?$/, loader: "url", query: {limit: 100, name: fontName}},
      {test: /\.svg(\?\S*)?$/, loader: "url", query: {limit: 10000, mimetype: "image/svg+xml", name: fontName}},
    ],
    noParse: [
      path.resolve('./node_modules/pdfviewer'),
      path.resolve('./node_modules/jquery'),
      path.resolve('./node_modules/rangy'),
      path.resolve('./node_modules/primus-client/primus.js')
    ]
  },
  externals: {
  },
  resolve: {
    extensions: ['', '.coffee', '.cjsx', '.jsx', '.less', '.js']
  },
  plugins: [
    new ExtractTextPlugin("css/#{fileName}.css")
    new webpack.optimize.CommonsChunkPlugin('vendor', if info.debug then 'js/vendor.js' else 'js/vendor.[chunkhash:8].js')
    if info.debug
      new SkipPlugin info: 'UglifyJsPlugin skipped'
    else
      new webpack.optimize.UglifyJsPlugin(compress: {warnings: false}, sourceMap: false)
    if info.debug
      new webpack.HotModuleReplacementPlugin()
    else
      new SkipPlugin info: 'HotModuleReplacementPlugin skipped'
    if info.debug
      new SkipPlugin info: 'React process.env skipped'
    else 
      new webpack.DefinePlugin("process.env": {NODE_ENV: JSON.stringify("production")})
    if info.debug
      new webpack.NoErrorsPlugin()
    else
      new SkipPlugin info: 'NoErrorsPlugin skipped'
    new webpack.ContextReplacementPlugin(/moment[\/\\]locale$/, /(zh-cn|en|zh-tw)$/)
    new webpack.DefinePlugin
      __DEV__: info.debug
      __GA__: false
  ]
  postcss: ->
    [
      autoprefixer browsers: ['last 2 versions', '> 1%']
      cssnano()
    ]
