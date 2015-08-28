express = require 'express'
passport = require('../utils/auth').passport
auth = require '../utils/auth'
sequelizeObject = require('../utils/sequelize').sequelizeObject

module.exports = sessionRoute = express.Router()

sessionRoute.post '/login', passport.authenticate('local'), (req, res) ->
  return res.plainText 'Welcome'

sessionRoute.post '/logout', (req, res) ->
  req.logout()
  return res.plainText 'Bye'

sessionRoute.get '/me', (req, res) ->
  return res.json sequelizeObject req.user, ['username', 'id', 'role']
