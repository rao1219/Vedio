# TODO not included into index
# angular.module 'vsvs'
# .controller 'RootController', [
#   '$scope'
#   'USER_ROLES'
#   'AUTH_EVENTS'
#   'AuthService'
#   ($scope, USER_ROLES, AUTH_EVENTS, AuthService) ->
#     $scope.currentUser = null
#     $scope.userRoles = USER_ROLES
#     $scope.isAuthorized = AuthService.isAuthorized
#     $scope.setCurrentUser = (user) ->
#       $scope.currentUser = user
#     # TODO yutian: this should be in login controller
#     $scope.login = (credentials) ->
#       AuthService
#       .login credentials
#       .then (user) ->
#         # TODO yutian: broadcast login success
#         $scope.setCurrentUser user
#       , ->
#         # TODO yutian: broadcast login failed
#         null
#     $scope.$on AUTH_EVENTS.notAuthorized, ->
#       alert 'not authorized'
#     return
#   ]
