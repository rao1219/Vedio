(function() {
  angular.module('finance', []).factory('currencyConverter', [
    '$http', function($http) {
      var convert, currencies, refresh, usdToForeignRates, yahooFinanceUrlPattern;
      yahooFinanceUrlPattern = '//query.yahooapis.com/v1/public/yql?q=select * from ' + 'yahoo.finance.xchange where pair in ("PAIRS")&format=json&' + 'env=store://datatables.org/alltableswithkeys&callback=JSON_CALLBACK';
      currencies = ['USD', 'EUR', 'CNY'];
      usdToForeignRates = {};
      convert = function(amount, inCurr, outCurr) {
        return amount * usdToForeignRates[outCurr] / usdToForeignRates[inCurr];
      };
      refresh = function() {
        var url;
        url = yahooFinanceUrlPattern.replace('PAIRS', 'USD' + currencies.join('","USD'));
        return $http.jsonp(url).success(function(data) {
          var newUsdToForeignRates;
          newUsdToForeignRates = {};
          angular.forEach(data.query.results.rate, function(rate) {
            var currency;
            currency = rate.id.substring(3, 6);
            return newUsdToForeignRates[currency] = window.parseFloat(rate.Rate);
          });
          return usdToForeignRates = newUsdToForeignRates;
        });
      };
      refresh();
      return {
        currencies: currencies,
        convert: convert,
        refresh: refresh
      };
    }
  ]);

}).call(this);
