express = require 'express'
module.exports = userRoute = express.Router()
auth = require '../utils/auth'
logger = require('../utils/log').newConsoleLogger module.filename
db = require '../models'
filterObjectByKey = require('../utils/misc').filterObjectByKey
sequelizeObject = require('../utils/sequelize').sequelizeObject
access = require '../middleware/access'

userRoute.param 'uid', (req, res, next, uid) ->
  req.checkParams('uid', 'int needed').notEmpty().isInt()

  checkErrors = req.validationErrors()
  return res.error checkErrors if checkErrors

  db.User.findById(uid)
  .then (user) ->
    if user?
      req.data.user = user

      req.access =
        key: 'user'
        fields: ['id', 'username', 'role']
      return next()
    else
      return res.noSuchObject('user')

userRoute.get '/:uid', access('get user profile'), (req, res) ->
  return res.json sequelizeObject req.data.user, ['id', 'username', 'role', 'createdAt']

userRoute.patch '/:uid', access((req, res) ->
  actions = []
  for key of req.body
    if key is 'role'
      actions.push 'update user role'
    else
      actions.push 'update user profile'
  actions
), (req, res) ->
  allowedKey = ['password', 'role']
  req.checkBody(key, 'value cannot be empty').optional().notEmpty() for key in allowedKey
  req.checkBody('role', 'not valid role').optional().isIn ['admin', 'uploader', 'reviewer', 'viewer']
  checkErrors = req.validationErrors()
  return res.error checkErrors if checkErrors

  if req.body?
    attrs = filterObjectByKey(req.body, allowedKey)
    logger.debug JSON.stringify attrs
    req.data.user.update attrs
    .then ->
      return res.plainText 'Updated'
    .catch (err) ->
      return res.error err
  else
    return res.error 'Body is not valid'

userRoute.delete '/:uid', access('delete user'), (req, res) ->
  req.data.user.destroy()
  .then ->
    return res.plainText 'Success'
  .catch (err) ->
    return res.error err

userRoute.get '/', access('get user list'), (req, res) ->
  req.sanitizeBody('limit').default(20)

  req.checkQuery('page', 'int needed').isInt()
  req.checkQuery('limit', 'int needed').isInt()
  checkErrors = req.validationErrors()
  return res.error checkErrors if checkErrors

  limit = req.query.limit
  page = req.query.page

  if page?
    db.User.findAndCountAll
      limit: limit
      offset: (page - 1) * limit
    .then (result) ->
      #logger.debug result
      return res.json
        users: (sequelizeObject(user, ['username', 'id', 'role']) for user in result.rows)
        total: result.count
    .catch (err) ->
      return res.error err
  else
    return res.error 'page is needed'

userRoute.post '/', access('create user'), (req, res) ->
  req.sanitizeBody('role').default('viewer')
  req.checkBody('username', 'invalid username').isAlphanumeric().notEmpty()
  req.checkBody('password', 'invalid password').notEmpty()
  req.checkBody('role', 'invalid role').isIn ['admin', 'uploader', 'reviewer', 'viewer' ]
  checkErrors = req.validationErrors()
  return res.error checkErrors if checkErrors

  db.User.create filterObjectByKey req.body, ['username', 'password', 'role']
  .then (user) ->
    return res
      .set 'location', "/user/#{user.get('id')}"
      .status 202
      .plainText 'Created'
  .catch (err) ->
    res.databaseError err
