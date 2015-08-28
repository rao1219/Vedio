(function() {
  angular.module('vsvs').controller('MainController', [
    '$rootScope', '$scope', 'ngProgressLite', 'Session', 'User', function($rootScope, $scope, ngProgressLite, Session, User) {
      if (!Session.initialized) {
        Session.updateStatus();
      }
      this.currentSession = Session;
      this.getProfile = function(id) {
        return User.getProfile(id).then(function(e) {
          return $scope.inputIDData = JSON.stringify(e);
        });
      };
      this.updateProfile = function(id, password) {
        return User.updateProfile(id, {
          password: password
        }).then(function() {
          return console.log('success');
        }, function() {
          return console.log('failed');
        });
      };
      $rootScope.$on('$stateChangeStart', function(event, toState, toParams, fromState, fromParams) {
        return ngProgressLite.start();
      });
      $rootScope.$on('$stateChangeSuccess', function(event, toState, toParams, fromState, fromParams) {
        return ngProgressLite.inc();
      });
      $rootScope.$on('$stateChangeError', function(event, toState, toParams, fromState, fromParams) {
        return ngProgressLite.set(0);
      });
      $rootScope.$on('$viewContentLoading', function(event, toState, toParams, fromState, fromParams) {
        return ngProgressLite.inc();
      });
      $rootScope.$on('$viewContentLoaded', function(event, toState, toParams, fromState, fromParams) {
        return ngProgressLite.done();
      });
    }
  ]);

}).call(this);
