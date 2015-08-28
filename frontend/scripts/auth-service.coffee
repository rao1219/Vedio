angular.module 'vsvs'
.constant 'AUTH_EVENTS',
  loginSuccess: 'auth-login-success'
  loginFailed: 'auth-login-failed'
  logoutSuccess: 'auth-logout-failed'
  sessionTimeout: 'auth-session-timeout'
  notAuthenticated: 'auth-not-authenticated'
  notAuthorized: 'auth-not-authorized'

.constant 'USER_ROLES',
  # TODO yutian: all?
  admin: 'admin'
  reviewer: 'reviewer'
  publisher: 'publisher'
  guest: 'guest'

.service 'AuthService', [
  '$http'
  '$timeout'
  'Session'
  ($http, $timeout, Session) ->
    @login = (credentials) ->
      # TODO yutian: contact backend, mock code now
      $timeout ->
        Session.create 'sessionId', 'userId', 'reviewer'
        role: 'reviewer'
        name: 'haha'
    @isAuthenticated = ->
      Session.authenticated
    @isAuthorized = (authorizedRoles) ->
      @isAuthenticated && authorizedRoles.indexOf(Session.userRole) != -1
    return
  ]

.service 'Session', [
  '$resource'
  ($resource) ->
    SessionResource = $resource 'http://end.vsvs.tunel.edu.cn/api/session/:action', {},
      login:
        method: 'POST'
        params:
          action: 'login'
      me:
        method: 'GET'
        params:
          action: 'me'
      logout:
        method: 'POST'
        params:
          action: 'logout'
    @updateStatus = ->
      new SessionResource()
      .$me()
      .then (ret) =>
        @username = ret.username
        @userID = ret.id
        @userRole = ret.role
        @initialized = true
    @login = (username, password) ->
      session = new SessionResource()
      session.username = username
      session.password = password
      session
      .$login()
      .then =>
        @updateStatus()
    @logout = ->
      new SessionResource()
      .$logout()
      .then =>
        @updateStatus()
    return
  ]
