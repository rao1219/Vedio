(function() {
  angular.module('vsvs').controller('SessionController', [
    '$resource', 'Session', function($resource, Session) {
      this.login = function(username, password) {
        console.log("username: " + username + " password: " + password);
        return Session.login(username, password).then(function() {
          return console.log('Good');
        }, function() {
          return console.log('login error');
        });
      };
      this.logout = function() {
        return Session.logout();
      };
    }
  ]);

}).call(this);
