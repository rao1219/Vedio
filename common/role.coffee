class Rule
  if: (@condition) -> @

  and: (condition) ->
    @andCondition = new Rule()
    @andCondition.if condition

  or: (condition) ->
    @orCondition = new Rule()
    @orCondition.if condition

  isAllowedTo: (subject, object) ->
    allowed = @condition(subject, object)
    allowed = allowed and @andCondition.isAllowedTo(subject, object) if @andCondition?
    allowed = allowed or @orCondition.isAllowedTo(subject, object) if @orCondition?
    return allowed

class User
  constructor: (@subject) -> undefined

  # This function is called from instance
  # to validate the permission.
  # Example:
  #   user = User(userObject)
  #   user.can('upload video') => true
  #   user.can('delete video', videoObject) => false
  #
  # If there is no related action, return false.
  #
  # > User cannot do something that do not exist,
  # > of course!
  can: (action, object) ->
    for rule in @constructor.rules[action] ? []
      if rule.isAllowedTo @subject, object
        return true
    return false

  # This function is called from class to
  # grant permission to users.
  #
  # if this function is called multiple time,
  # the relation between the rules is *or*.
  #
  # Permission granted with this function
  # is stored in @rules.
  # Example:
  #   User.can 'upload video'
  #   .if (user) -> user.role is 'admin'
  #   .or (user) -> user.role is 'uploader'
  #
  #   User.can 'submit video'
  #   .if (user) -> user.id is video.owner
  #   .or (user, video) -> user.role is 'admin'
  #
  # Roadmap:
  #   regex
  @rules = {}
  @can: (action) =>
    console.log "Create new rule for #{action}"
    if not (action of @rules)
      @rules[action] = []

    @rules[action].push rule = new Rule(@)
    rule

# Test Only rule
# This will not influence the results
User.can('update user profile').if (subject, object) ->
  console.log "rule: Subject is => #{JSON.stringify subject}"
  console.log "rule: Object is => #{JSON.stringify object}"
  false
###
Begin of rules
###
User.can 'get user profile'
.if -> true

User.can 'update user profile'
.if (user) -> user.role is 'admin'
.or (user, toUser) -> user.id is toUser.id

User.can 'update user role'
.if (user) -> user.role is 'admin'
.and (user, toUser) -> user.id isnt toUser.id

User.can 'delete user'
.if (user) -> user.role is 'admin'
.and (user, toUser) -> user.id != toUser.id

User.can 'get user list'
.if (user) -> user.role is 'admin'

User.can 'create user'
.if -> true

User.can 'upload video'
.if (user) -> user.role is 'admin'
.or (user) -> user.role is 'uploader'

User.can 'delete video'
.if (user) -> user.role is 'admin'
.or (user, video) -> user.role is 'uploader' and user.id is video.owner and video.status is 'uploaded'
###
End of rules
###

module.exports = User
