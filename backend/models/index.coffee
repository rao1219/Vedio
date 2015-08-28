logger = require('../utils/log').newConsoleLogger module.filename
fs = require 'fs'
path = require 'path'
Sequelize = require 'sequelize'
config = require '../config'
sequelize = new Sequelize(config.db)
db = {}

fs
.readdirSync(__dirname)
.filter (file) ->
  file.indexOf('.') != 0 and file != __filename.split(path.sep).pop()
.forEach (file) ->
  model = sequelize.import path.join(__dirname, file)
  db[model.name] = model

for modelName, Model of db
  logger.debug("#{modelName} has associate: #{'associate' of Model}")
  Model.associate db if 'associate' of Model

db.sequelize = sequelize
db.Sequelize = Sequelize

module.exports = db
