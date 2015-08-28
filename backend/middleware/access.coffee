# Generate middleware with given action
#
# Action strings could be passed directly,
# or callback is passed, which should return a list of action strings.
#
# The relation between action strings is `AND`
#
# Example:
#   access 'update user profile', 'update user role'
#
#   access (req, res) -> ['update user profile', 'update user role']
#
# Above examples are equal.
#
# Object is retrieved from req.data according to req.access
#
# Example:
#   If
#   req.access =
#     key: 'user'
#     fields: ['id', 'username', 'role']
#
#   Then
#   object = sequelizeObject req.data.user, ['id', 'username', 'role']
#
#   Or
#   req.access = undefined
#
#   Then
#   object = undefined
#
# req.access is designed to be set in app.param
logger = require('../utils/log').newConsoleLogger module.filename
Role = require '../../common/role'
sequelizeObject = require('../utils/sequelize').sequelizeObject

module.exports = (args...) ->
  (req, res, next) ->
    if args.length is 1 and typeof args[0] is 'function'
      actions = args[0] req, res
    else
      actions = args

    role = new Role(sequelizeObject req.user, ['username', 'id', 'role'])
    object = sequelizeObject req.data[req.access.key], req.access.fields if req.access?

    for action in actions
      unless role.can(action, object)
        return res
        .status 403
        .plainText 'Forbidden'
    return next()
