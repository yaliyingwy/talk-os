Immutable = require 'immutable'

dispatcher = require '../dispatcher'
api        = require '../network/api'

lang = require '../locales/lang'

notifyActions = require '../actions/notify'

exports.createDaily = (data, success, fail) ->
  console.log('createDaily:', data);
  api.dailies.create.post data: data
    .then (resp) ->
      notifyActions.success lang.getText('daily-created', 'zh')
      dispatcher.handleViewAction type: 'daily/create', data: resp
      success? Immutable.fromJS(resp)
    .catch (error) ->
      notifyActions.error lang.getText('daily-create-failed', 'zh')
      fail? error

exports.readDaily = (_teamId, success, fail) ->
  api.dailies.read.get(queryParams: _teamId: _teamId)
    .then (resp) ->
      dispatcher.handleViewAction type: 'daily/read', data: resp
      success? Immutable.fromJS(resp)
    .catch (error) ->
      fail? error

exports.pmList = (success, fail) ->
  api.dailies.pm.get()
    .then (resp) ->
      dispatcher.handleViewAction type: 'daily/pm', data: resp
      success? Immutable.fromJS(resp)
    .catch (error) ->
      fail? error

exports.createExcel = (data, success, fail) ->
  api.download "/v2/dailies/excel?_ids=#{data._ids}"

exports.sendDaily = (data, success, fail) ->
  api.dailies.send.post data: data
    .then (resp) ->
      notifyActions.success lang.getText('daily-sended')
      dispatcher.handleViewAction type: 'daily/send', data: data
      success? Immutable.fromJS(resp)
    .catch (error) ->
      notifyActions.error lang.getText('daily-send-failed')
      fail? error

exports.clearResults = ->
  dispatcher.handleViewAction type: 'daily-result/clear'
