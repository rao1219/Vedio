(function() {
  angular.module('vsvs').config([
    '$stateProvider', '$urlRouterProvider', 'USER_ROLES', function($stateProvider, $urlRouterProvider, USER_ROLES) {
      $urlRouterProvider.otherwise('/home');
      return $stateProvider.state('home', {
        url: '/home',
        templateUrl: 'home.html'
      }).state('login', {
        url: '/login',
        templateUrl: 'login.html'
      }).state('upload', {
        url: '/upload',
        templateUrl: 'upload.html'
      }).state('member', {
        url: '/member',
        templateUrl: 'member.html'
      }).state('restricted', {
        url: '/restricted',
        template: '<h1>Testing a restricted page, you shall not pass!</h1>'
      });
    }
  ]).run([
    '$rootScope', 'AUTH_EVENTS', 'AuthService', function($rootScope, AUTH_EVENTS, AuthService) {
      return null;
    }
  ]);

}).call(this);
