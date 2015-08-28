express = require 'express'
bodyParser = require 'body-parser'
expressValidator = require 'express-validator'
db = require '../models'

module.exports = apiRoute = express.Router()

apiRoute.use bodyParser.json()
apiRoute.use expressValidator
  customSanitizers:
    default: (value, defaultValue) ->
      value ? defaultValue

apiRoute.use (req, res, next) ->
  # Default user for anonymous user
  req.user = req.user ? db.User.build
    username: 'anonymous'
    role: 'viewer'
    id: null

  next()

apiRoute.use (req, res, next) ->
  # Place to store resolved datas
  req.data = {}

  # Helper methods

  # set `content-type` to `text/plain` and
  # send text with appending EOL
  res.plainText = (text) ->
    res
    .type('text/plain')
    .send("#{text}\n")

  # Shorthand to return error
  res.error = (err) ->
    res
    .status 400
    .json err

  # Shorthand to return `No such Object` error
  res.noSuchObject = (object) ->
    res
    .status 404
    .plainText "No such #{object ? 'object'}"

  # Called with database error
  res.databaseError = (err) ->
    conflicts = []
    for error in err.errors
      if error.type == 'unique violation'
        conflicts.push error.path

    if conflicts
      return res
      .status 409
      .json
        conflicts: conflicts
    else
      return res.error err

  next()

apiRoute.use '/session', require './session'
apiRoute.use '/user', require './user'
