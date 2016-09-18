C = require('../../constants')

module.exports = (SelGenApp) ->
  SelGenApp.controller 'ListSelController', [ '$scope', '$rootScope', ($scope, $rootScope) ->
    $scope.selAttributes = []
    $scope.selTypes = [
      { name: 'text', displayName: 'Text' },
      { name: 'image', displayName: 'Image' }
    ]
    $scope.clickDelete = (index) ->
      $scope.selAttributes.splice(index, 1)
    $rootScope.$on(C.Broadcasts.ListSel.AddSingleAttr,
      (event, {attributeName, selectorText}) ->
        $scope.$apply ->
          $scope.selAttributes.push(
            name: attributeName,
            cssText: selectorText
          )
    )
  ]


