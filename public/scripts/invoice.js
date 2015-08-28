(function() {
  var app;

  app = angular.module('invoice', ['finance', 'ui.router']);

  app.controller('InvoiceController', [
    'currencyConverter', function(currencyConverter) {
      this.qty = 1;
      this.cost = 2;
      this.inCurr = 'EUR';
      this.currencies = currencyConverter.currencies;
      this.total = function(outCurr) {
        return currencyConverter.convert(this.qty * this.cost, this.inCurr, outCurr);
      };
      this.pay = function() {
        return window.alert('Thanks!');
      };
    }
  ]);

  app.config([
    '$stateProvider', '$urlRouterProvider', '$locationProvider', function($stateProvider, $urlRouterProvider, $locationProvider) {
      $urlRouterProvider.otherwise('/state1');
      return $stateProvider.state('state1', {
        url: '/state1',
        templateUrl: 'state1.html'
      }).state('state1.list', {
        url: '/list',
        templateUrl: 'state1.list.html',
        controller: [
          '$scope', function($scope) {
            $scope.items = ['A', 'List', 'Of', 'Items'];
          }
        ]
      }).state('state2', {
        url: '/state2',
        templateUrl: 'state2.html'
      }).state('state2.list', {
        url: '/list',
        templateUrl: 'state2.list.html',
        controller: [
          '$scope', function($scope) {
            $scope.things = ['A', 'Set', 'Of', 'Things'];
          }
        ]
      });
    }
  ]);

}).call(this);
