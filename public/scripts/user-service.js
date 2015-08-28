(function() {
  angular.module('vsvs').service('User', [
    '$resource', function($resource) {
      var UserResource;
      UserResource = $resource('http://end.vsvs.tunel.edu.cn/api/user/:id', {}, {
        getProfile: {
          method: 'GET',
          params: {
            id: '@id'
          }
        },
        updateProfile: {
          method: 'PATCH',
          params: {
            id: '@id'
          }
        }
      });
      this.getProfile = function(id) {
        var user;
        user = new UserResource();
        user.id = id;
        return user.$getProfile();
      };
      this.updateProfile = function(id, content) {
        var k, user, v;
        user = new UserResource();
        user.id = id;
        for (k in content) {
          v = content[k];
          user[k] = v;
        }
        return user.$updateProfile();
      };
    }
  ]);

}).call(this);
