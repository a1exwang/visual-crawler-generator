Utils = require '../../utils'
C = require('../../constants')
module.exports = (SelGenApp) ->
  SelGenApp.controller 'ItemSelController', ['$scope', '$rootScope', ($scope, $rootScope) ->
    $scope.selAttributes = []

    $rootScope.$on 'ItemSelController::onDelete', (event, index) ->
      $scope.selAttributes.splice(index, 1)

    $rootScope.$on(C.Broadcasts.ItemSel.AddSingleAttr, (event, selectorText) ->
      elements = window.innerDocument.querySelectorAll(selectorText)
      selectedHTML = elements[0].outerHTML
      selectedText = $(elements).text()
      $scope.$apply ->
        $scope.selAttributes.push(
          name: '',
          cssText: selectorText,
          selectedHTML: selectedHTML,
          selectedText: selectedText,
          type: 'text',
          elements: elements,
          backgroundColor: C.Colors[Utils.randInt(0, C.Colors.length)]
        )
    )
  ]
  SelGenApp.controller 'ItemSelItemController', ['$scope', '$rootScope', ($scope, $rootScope) ->
    $scope.selTypes = [
      { name: 'text', displayName: 'Text' },
      { name: 'image', displayName: 'Image' }
    ]
    data = $scope['selAttr']
    $scope.$watch('selAttr.backgroundColor', (color) ->
      $(data.elements).css('background-color', color)
#      $(data.elements).css('border-style', 'solid').css('border-color', 'red')
    )
    $scope.onDelete = (index) ->
      $(data.elements).css('background-color', 'white')
      $rootScope.$broadcast('ItemSelController::onDelete', index)
  ]

