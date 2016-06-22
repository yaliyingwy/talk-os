
Immutable = require 'immutable'

# https://jianliao.com/doc/restful/favorite.read.html
exports.read = (store, dailyList) ->
  _teamId = store.getIn(['device', '_teamId'])

  store.setIn ['dailies', _teamId], dailyList

exports.pm = (store, pmList) ->
  store.set 'pmList', pmList

exports.send = (store, data) ->
  dailyList = store.getIn(['dailies', data.get('_teamId')])
  dailyList = dailyList.map (daily) ->
    daily.set('send', daily.get('_id') in data.get('_ids').split(','))
  store.setIn ['dailies', data.get('_teamId')], dailyList

# https://jianliao.com/doc/restful/favorite.remove.html
exports.remove = (store, dailyData) ->
  _teamId = dailyData.get('_teamId')
  _dailyId = dailyData.get('_id')
  inCollection = (daily) -> daily.get('_id') is _dailyId

  store
  .updateIn ['dailies', _teamId], (dailyList) ->
    if dailyList?
      dailyList.filterNot inCollection
    else Immutable.List()

exports.create = (store, daily) ->
  _teamId = daily.get('_teamId')
  store
  .updateIn ['dailies', _teamId], (dailyList) ->
    if dailyList?
      index = dailyList.findIndex (d) ->
        d.get('_id') is daily.get('_id')
      if index isnt -1
        dailyList.update index, (d) ->
          daily
      else
        dailyList.unshift daily
    else Immutable.List [daily]
