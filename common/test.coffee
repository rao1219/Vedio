# Simple test for role.coffee
User = require './role'

users = [
  {
    id: 1
    username: 'admin'
    role: 'admin'
  }
  {
    id: 2
    username: 'uploader'
    role: 'uploader'
  }
  {
    id: 3
    username: 'reviewer'
    role: 'reviewer'
  }
  {
    id: undefined
    username: 'anonymous'
    role: 'viewer'
  }
]

videoActionsWithoutObject = [
  'upload video'
]

videoActionsWithObject = [
  'delete video'
]

userActionsWithoutObject = [
  'get user profile'
  'get user list'
  'create user'
]

userActionsWithObject = [
  'update user profile'
  'delete user'
]

videoObject =
  id: 1
  description: 'dummy video'
  owner: 2
  status: 'uploaded'

for userObject in users
  user = new User(userObject)
  for action in videoActionsWithoutObject
    console.log "Can
      #{userObject.username}(#{userObject.role})##{userObject.id}
      `#{action}`? #{user.can action }"

  for action in videoActionsWithObject
    console.log "Can
      #{userObject.username}(#{userObject.role})##{userObject.id}
      `#{action}` to Video##{videoObject.id}(owned by #{videoObject.owner})?
      #{user.can action, videoObject}"

  for action in userActionsWithoutObject
    console.log "Can
      #{userObject.username}(#{userObject.role})##{userObject.id}
      `#{action}`? #{user.can action }"

  toUser = users[1]
  for action in userActionsWithObject
    console.log "Can
      #{userObject.username}(#{userObject.role})##{userObject.id}
      `#{action}` to
      User##{toUser.username}(#{toUser.role})##{toUser.id}?
      #{user.can action, toUser}"
