angular.module 'vsvs'
.service 'User', [
  '$resource'
  ($resource) ->
    UserResource = $resource 'http://end.vsvs.tunel.edu.cn/api/user/:id', {},
      getProfile:
        method: 'GET'
        params:
          id: '@id'
      updateProfile:
        method: 'PATCH'
        params:
          id: '@id'
    @getProfile = (id) ->
      user = new UserResource()
      user.id = id
      user
      .$getProfile()
    @updateProfile = (id, content) ->
      user = new UserResource()
      user.id = id
      for k, v of content
        user[k] = v
      user.$updateProfile()
    return
]
