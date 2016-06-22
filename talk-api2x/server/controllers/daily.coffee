_ = require 'lodash'
Err = require 'err1st'
limbo = require 'limbo'
app = require '../server'
moment = require 'moment'
excel = require 'excel-export'
nodemailer = require 'nodemailer'

config = require '/data/config.js'

{
  DailyModel
  TeamModel
} = limbo.use 'talk'

_transporter = nodemailer.createTransport config.mail

module.exports = dailyController = app.controller 'daily', ->

  @mixin require './mixins/permission'

  @ensure 'work', only: 'create update'
  @ensure '_teamId', only: 'create read send'
  @ensure '_ids', only: 'excel send'

  @before 'isTeamMember', only: 'create read'
  @before 'editableDaily', only: 'update remove'
  @before 'isTeamAdmin', only: 'send'
  editableFields = [
    'project'
    'work'
    'pm'
    'testDate'
    'productionDate'
    'progress'
  ]

  @action 'create', (req, res, callback) ->
    {data, _teamId, socketId, _sessionUserId} = req.get()
    today = moment().startOf('day')
    tomorrow = moment(today).add(1, 'days') 
    conditions =
      creator: _sessionUserId
      updatedAt: $gte: today.toDate(), $lt: tomorrow.toDate() 
      team: _teamId
    update = _.pick req.get(), editableFields
    update.updatedAt = new Date()
    update.creator = _sessionUserId
    update.team = _teamId
    DailyModel.findOneAndSave conditions, update, {upsert: true}, (err, daily)->
      console.log 'daily---', daily
      if err
        console.error err
        callback err, null
      else
        DailyModel.populate(daily, {path: 'creator', select: 'name'}, (err, daily) ->
          callback err, daily)

  @action 'read', (req, res, callback) ->
    {_teamId} = req.get()
    today = moment().startOf('day')
    tomorrow = moment(today).add(1, 'days')
    DailyModel.find
      team: _teamId
      updatedAt: $gte: today.toDate(), $lt: tomorrow.toDate()
    .populate 'creator', 'name'
    .exec callback

  @action 'update', (req, res, callback) ->
    {_id} = req.get()
    update = _.pick req.get() editableFields
    update.updatedAt = new Date
    DailyModel.findOneAndSave _id: _id, update, callback

  @action 'pm', (req, res, callback) ->
    callback null, config.pmList

  @action 'excel', (req, res, callback) ->
    {_ids} = req.get()
    DailyModel.find
      _id: $in: _ids.split(',')
    .populate 'creator', 'name'
    .exec (err, dailyList) ->
      conf = {
        # stylesXmlFile: '日报.xml'
        name: 'daily'
        cols: ({
          caption:title
          type: 'string'
          width: 100
          } for title in ['姓名', '项目', '工作', '进度', '产品', '提测时间', '上线时间'])
        rows: ([
          daily.creator.name
          daily.project
          daily.work
          daily.progress * 100 + '%'
          daily.pm
          moment(daily.testDate).format('YYYY/MM/DD')
          moment(daily.productionDate).format('YYYY/MM/DD')
          ] for daily in dailyList)
      }
      result = excel.execute(conf)
      res.setHeader 'Content-Type', 'application/vnd.openxmlformats'
      res.setHeader 'Content-Disposition', 'attachment; filename=Report.xlsx'
      res.end result, 'binary'

  @action 'send', (req, res, callback) ->
    {_ids,_teamId} = req.get()
    DailyModel.find
      _id: $in: _ids.split(',')
    .populate 'creator', 'name'
    .exec (err, dailyList) ->
      for daily in dailyList
        daily.send = true
        daily.save()
      conf = {
        # stylesXmlFile: '日报.xml'
        name: 'daily'
        cols: ({
          caption:title
          type: 'string'
          width: 100
          } for title in ['姓名', '项目', '工作', '进度', '产品', '提测时间', '上线时间'])
        rows: ([
          daily.creator.name
          daily.project
          daily.work
          daily.progress * 100 + '%'
          daily.pm
          moment(daily.testDate).format('YYYY/MM/DD')
          moment(daily.productionDate).format('YYYY/MM/DD')
          ] for daily in dailyList)
      }
      result = excel.execute(conf)

      mailOptions = 
        from: config.from
        to: config.to
        attachments: [
          filename: "dailyReport#{new Date().toLocaleDateString()}.xlsx"
          contentType: 'application/vnd.openxmlformats'
          contentDisposition: 'attachment; filename=dailyReport.xlsx'
          content: result
          encoding: 'binary'
        ]
      TeamModel.findOne {_id: _teamId}, (err, team) ->
        if err
          console.error err
          callback err, { msg: '日报发送失败' }
        else
          mailOptions.subject = team.name + '日报' + new Date().toLocaleDateString()
          mailOptions.text = "这是的#{team.name}日报\n"
          _transporter.sendMail mailOptions, (error, info) ->
            if error
              console.error error
              callback error, { msg: '日报发送失败'}
            else
              callback null, { msg: '日报发送成功！'}
            
        

  @action 'remove', (req, res, callback) ->
    {_id, daily, socketId} = req.get()
    daily.socketId = socketId
    daily.remove callback
