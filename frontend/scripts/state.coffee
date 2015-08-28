angular.module 'vsvs'
.config [
  '$stateProvider'
  '$urlRouterProvider'
  'USER_ROLES'
  ($stateProvider, $urlRouterProvider, USER_ROLES) ->
    $urlRouterProvider.otherwise '/home'
    $stateProvider
    .state 'home',
      url: '/home'
      templateUrl: 'home.html'
    .state 'login',
      url: '/login'
      templateUrl: 'login.html'
    .state 'upload',
      url: '/upload'
      templateUrl: 'upload.html'
    .state 'member',
      url: '/member'
      templateUrl: 'member.html'
    .state 'restricted',
      url: '/restricted'
      template: '<h1>Testing a restricted page, you shall not pass!</h1>'
  ]
.run [
  '$rootScope'
  'AUTH_EVENTS'
  'AuthService'
  ($rootScope, AUTH_EVENTS, AuthService) ->
    null
    # $rootScope.$on '$stateChangeStart', (event, next) ->
    #   authorizedRoles = next.data.authorizedRoles
    #   if !AuthService.isAuthorized(authorizedRoles)
    #     event.preventDefault()
    #     if AuthService.isAuthenticated()
    #       $rootScope.$broadcast AUTH_EVENTS.notAuthorized
    #     else
    #       $rootScope.$broadcast AUTH_EVENTS.notAutheticated
  ]
