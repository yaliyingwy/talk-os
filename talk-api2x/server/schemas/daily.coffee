###
Indexes:
* db.tags.ensureIndex({team: 1, name: 1}, {unique: true, background: true})
###

{Schema} = require 'mongoose'
_ = require 'lodash'

module.exports = DailySchema = new Schema
  creator: type: Schema.Types.ObjectId, ref: 'User'
  team: type: Schema.Types.ObjectId, ref: 'Team'
  project: type: String
  work: type: String
  testDate: type: Date, default: Date.now
  productionDate: type: Date, default: Date.now
  pm: type: String
  send: type: Boolean, default: false
  progress: type: Number, min: 0, max: 1
  createdAt: type: Date, default: Date.now
  updatedAt: type: Date, default: Date.now
,
  read: 'secondaryPreferred'
  toObject:
    virtuals: true
    getters: true
  toJSON:
    virtuals: true
    getters: true

# ============================== Virtuals ==============================
DailySchema.virtual '_teamId'
  .get -> @team?._id or @team
  .set (_id) -> @team = _id

DailySchema.virtual '_creatorId'
  .get -> @creator?._id or @creator
  .set (_id) -> @creator = _id
# ============================== methods ==============================
