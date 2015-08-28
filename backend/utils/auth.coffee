LocalStrategy = require('passport-local').Strategy
passport = require 'passport'
db = require '../models'
logger = require('../utils/log').newConsoleLogger module.filename

initPassport = (passport) ->
  passport.serializeUser (user, done) -> done null, user.id

  passport.deserializeUser (id, done) ->
    db.User
    .findById id
    .done (user) -> done null, user
    , (err) -> done err, null

  passport.use(new LocalStrategy((username, password, done) ->
    logger.debug 'Password is: ' + password
    db.User
    .find where: username: username
    .done (user) ->
      if not user
        logger.debug 'Unknown user'
        done null, false, message: 'Unknown user'
      else if password != user.password
        logger.debug 'Invalid password'
        done null, false, message: 'Invalid password'
      else
        logger.debug 'password matched'
        done null, user
  ))

exports.initApp = (app) ->
  app.use passport.initialize()
  app.use passport.session()

  initPassport passport

exports.passport = passport
