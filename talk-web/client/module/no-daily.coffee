React = require 'react'
PureRenderMixin = require 'react-addons-pure-render-mixin'

div  = React.createFactory 'div'
span = React.createFactory 'span'
lang = require '../locales/lang'

module.exports = React.createClass
  displayName: 'no-favorite'
  mixins: [PureRenderMixin]

  render: ->
    div className: 'no-favorite',
      span className: "ti ti-star-solid"
      div className: "message", lang.getText('no-daily')
      div className: 'tip', lang.getText('no-daily-tip')
