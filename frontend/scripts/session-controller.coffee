angular.module 'vsvs'
.controller 'SessionController', [
  '$resource'
  'Session'
  ($resource, Session) ->
    @login = (username, password) ->
      console.log "username: #{username} password: #{password}"
      Session.login username, password
      .then ->
        console.log 'Good'
      , ->
        console.log 'login error'
      # TODO return promise change state
    @logout = ->
      Session.logout()
    # @register = (username, password) ->
    #   alert gettextCatalog.getString(
    #     'register as {{username}}:{{password}}',
    #     username: username
    #     password: password
    #   )
    return
]
