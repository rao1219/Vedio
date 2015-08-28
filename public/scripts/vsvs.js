(function() {
  var app,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  app = angular.module('vsvs', ['ngFileUpload', 'ngResource', 'ngProgressLite', 'ui.router', 'gettext', 'ui.bootstrap', 'toastr']);

  app.controller('LoginController', [
    '$http', 'gettextCatalog', function($http, gettextCatalog) {
      this.login = function(username, password) {
        return $http.post('/api/session/login', {
          username: username,
          password: password
        }).success(function(data, status, headers, config) {
          return alert(data);
        }).error(function(data, status, headers, config) {
          return alert(data);
        });
      };
      this.register = function(username, password) {
        return alert(gettextCatalog.getString('register as {{username}}:{{password}}', {
          username: username,
          password: password
        }));
      };
    }
  ]);

  app.controller('LanguageController', [
    'gettextCatalog', function(gettextCatalog) {
      this.setLanguage = function(lang) {
        gettextCatalog.setCurrentLanguage(lang);
        return gettextCatalog.loadRemote('/languages/messages-' + lang + '.json');
      };
    }
  ]);

  app.controller('UploadController', [
    '$scope', 'toastr', 'gettextCatalog', function($scope, toastr, gettextCatalog) {
      $scope.fileList = [];
      $scope.progress = 45;
      this.addFile = function(files) {
        var file, i, len;
        for (i = 0, len = files.length; i < len; i++) {
          file = files[i];
          file.status = 'pending';
          if (indexOf.call($scope.fileList, file) < 0) {
            $scope.fileList.push(file);
          }
        }
        return console.log($scope.fileList);
      };
      this.validate = function(file) {
        var ref;
        if ((ref = file.name.split('.').pop()) === 'webm' || ref === 'mp4' || ref === 'flv' || ref === 'mov') {
          toastr.info(gettextCatalog.getString('Success: {{filename}} is uploading.', {
            filename: file.name
          }));
          return true;
        } else {
          toastr.warning(gettextCatalog.getString('Failed: {{filename}} is not valid video.', {
            filename: file.name
          }));
          return false;
        }
      };
    }
  ]);

  app.controller('LoginController', [
    '$http', 'gettextCatalog', function($http, gettextCatalog) {
      this.login = function(username, password) {
        return $http.post('/login', {
          username: username,
          password: password
        }).success(function(data, status, headers, config) {
          return alert(data);
        }).error(function(data, status, headers, config) {
          return alert(data);
        });
      };
      this.register = function(username, password) {
        return alert(gettextCatalog.getString('register as {{username}}:{{password}}', {
          username: username,
          password: password
        }));
      };
    }
  ]).controller('LanguageController', [
    'gettextCatalog', function(gettextCatalog) {
      this.setLanguage = function(lang) {
        gettextCatalog.setCurrentLanguage(lang);
        return gettextCatalog.loadRemote('/languages/messages-' + lang + '.json');
      };
    }
  ]);

  app.config([
    'ngProgressLiteProvider', function(ngProgressLiteProvider) {
      return ngProgressLiteProvider.settings.speed = 500;
    }
  ]);

}).call(this);
