app = angular.module 'vsvs', [
  'ngFileUpload'
  'ngResource'
  'ngProgressLite'
  'ui.router'
  'gettext'
  'ui.bootstrap'
  'toastr'
]

app.controller 'LoginController', ['$http', 'gettextCatalog', ($http, gettextCatalog) ->
  @login = (username, password) ->
    $http.post '/api/session/login',
      username: username,
      password: password
    .success (data, status, headers, config) ->
      alert data
    .error (data, status, headers, config) ->
      alert data

  @register = (username, password) ->
    alert gettextCatalog.getString(
      'register as {{username}}:{{password}}',
      username: username
      password: password
    )

  return
]

app.controller 'LanguageController', ['gettextCatalog', (gettextCatalog) ->
  @setLanguage = (lang) ->
    gettextCatalog.setCurrentLanguage(lang)
    gettextCatalog.loadRemote '/languages/messages-' + lang + '.json'

  return
]

app.controller 'UploadController', ['$scope', 'toastr', 'gettextCatalog', ($scope, toastr, gettextCatalog) ->

  $scope.fileList = []
  $scope.progress = 45

  @addFile = (files) ->
    for file in files
      file.status = 'pending'
      $scope.fileList.push(file) if file not in $scope.fileList
    console.log $scope.fileList

  @validate = (file) ->
    if file.name.split('.').pop() in ['webm', 'mp4', 'flv', 'mov']
      toastr.info gettextCatalog.getString('Success: {{filename}} is uploading.',
        filename: file.name
      )
      return true
    else
      toastr.warning gettextCatalog.getString('Failed: {{filename}} is not valid video.',
        filename: file.name
      )
      return false

  return
]

app.controller 'LoginController', [
  '$http'
  'gettextCatalog'
  ($http, gettextCatalog) ->
    @login = (username, password) ->
      $http.post '/login',
        username: username,
        password: password
      .success (data, status, headers, config) ->
        alert data
      .error (data, status, headers, config) ->
        alert data

    @register = (username, password) ->
      alert gettextCatalog.getString(
        'register as {{username}}:{{password}}',
        username: username
        password: password
      )
    return
  ]
.controller 'LanguageController', [
  'gettextCatalog'
  (gettextCatalog) ->
    @setLanguage = (lang) ->
      gettextCatalog.setCurrentLanguage(lang)
      gettextCatalog.loadRemote '/languages/messages-' + lang + '.json'
    return
  ]

app.config [
  'ngProgressLiteProvider'
  (ngProgressLiteProvider) ->
    ngProgressLiteProvider.settings.speed = 500
]
