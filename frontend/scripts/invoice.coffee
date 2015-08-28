app = angular.module 'invoice', ['finance', 'ui.router']

app.controller 'InvoiceController', ['currencyConverter', (currencyConverter) ->
  @qty = 1
  @cost = 2
  @inCurr = 'EUR'
  @currencies = currencyConverter.currencies
  @total = (outCurr) ->
    currencyConverter.convert @qty * @cost, @inCurr, outCurr
  @pay = ->
    window.alert 'Thanks!'
  return
]

app.config [
  '$stateProvider',
  '$urlRouterProvider',
  '$locationProvider',
  ($stateProvider, $urlRouterProvider, $locationProvider) ->
    # $locationProvider.html5Mode
    #   enabled: true
    #   requireBase: false
    $urlRouterProvider.otherwise '/state1'
    $stateProvider
    .state 'state1',
      url: '/state1'
      templateUrl: 'state1.html'
    .state 'state1.list',
      url: '/list'
      templateUrl: 'state1.list.html'
      controller: ['$scope', ($scope) ->
        $scope.items = ['A', 'List', 'Of', 'Items']
        return
      ]
    .state 'state2',
      url: '/state2'
      templateUrl: 'state2.html'
    .state 'state2.list',
      url: '/list'
      templateUrl: 'state2.list.html'
      controller: ['$scope', ($scope) ->
        $scope.things = ['A', 'Set', 'Of', 'Things']
        return
      ]
]
