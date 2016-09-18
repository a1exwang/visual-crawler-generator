module.exports = (SelGenApp) ->
  SelGenApp.controller 'AddressBarController', ['$scope', '$rootScope',
    ($scope, $rootScope) ->
      $rootScope.$on 'urlChanged', (event, url) ->
        $scope.$apply ->
          $scope.url = url
    ]

