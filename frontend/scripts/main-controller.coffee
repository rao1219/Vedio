angular.module 'vsvs'
.controller 'MainController', [
  '$rootScope'
  '$scope'
  'ngProgressLite'
  'Session'
  'User'
  ($rootScope, $scope, ngProgressLite, Session, User) ->
    # TODO debugging
    # TODO set session or get /session/me on start
    if not Session.initialized
      Session.updateStatus()
    @currentSession = Session
    @getProfile = (id) ->
      User.getProfile(id)
      .then (e) ->
        $scope.inputIDData = JSON.stringify e
    @updateProfile = (id, password) ->
      User.updateProfile id,
        password: password
      .then ->
        console.log 'success'
      , ->
        console.log 'failed'

    $rootScope.$on '$stateChangeStart',
      (event, toState, toParams, fromState, fromParams) ->
        ngProgressLite.start()

    $rootScope.$on '$stateChangeSuccess',
      (event, toState, toParams, fromState, fromParams) ->
        ngProgressLite.inc()

    $rootScope.$on '$stateChangeError',
      (event, toState, toParams, fromState, fromParams) ->
        ngProgressLite.set(0)

    $rootScope.$on '$viewContentLoading',
      (event, toState, toParams, fromState, fromParams) ->
        ngProgressLite.inc()

    $rootScope.$on '$viewContentLoaded',
      (event, toState, toParams, fromState, fromParams) ->
        ngProgressLite.done()

    return
  ]
