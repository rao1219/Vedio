(function() {
  angular.module('vsvs').constant('AUTH_EVENTS', {
    loginSuccess: 'auth-login-success',
    loginFailed: 'auth-login-failed',
    logoutSuccess: 'auth-logout-failed',
    sessionTimeout: 'auth-session-timeout',
    notAuthenticated: 'auth-not-authenticated',
    notAuthorized: 'auth-not-authorized'
  }).constant('USER_ROLES', {
    admin: 'admin',
    reviewer: 'reviewer',
    publisher: 'publisher',
    guest: 'guest'
  }).service('AuthService', [
    '$http', '$timeout', 'Session', function($http, $timeout, Session) {
      this.login = function(credentials) {
        return $timeout(function() {
          Session.create('sessionId', 'userId', 'reviewer');
          return {
            role: 'reviewer',
            name: 'haha'
          };
        });
      };
      this.isAuthenticated = function() {
        return Session.authenticated;
      };
      this.isAuthorized = function(authorizedRoles) {
        return this.isAuthenticated && authorizedRoles.indexOf(Session.userRole) !== -1;
      };
    }
  ]).service('Session', [
    '$resource', function($resource) {
      var SessionResource;
      SessionResource = $resource('http://end.vsvs.tunel.edu.cn/api/session/:action', {}, {
        login: {
          method: 'POST',
          params: {
            action: 'login'
          }
        },
        me: {
          method: 'GET',
          params: {
            action: 'me'
          }
        },
        logout: {
          method: 'POST',
          params: {
            action: 'logout'
          }
        }
      });
      this.updateStatus = function() {
        return new SessionResource().$me().then((function(_this) {
          return function(ret) {
            _this.username = ret.username;
            _this.userID = ret.id;
            _this.userRole = ret.role;
            return _this.initialized = true;
          };
        })(this));
      };
      this.login = function(username, password) {
        var session;
        session = new SessionResource();
        session.username = username;
        session.password = password;
        return session.$login().then((function(_this) {
          return function() {
            return _this.updateStatus();
          };
        })(this));
      };
      this.logout = function() {
        return new SessionResource().$logout().then((function(_this) {
          return function() {
            return _this.updateStatus();
          };
        })(this));
      };
    }
  ]);

}).call(this);
