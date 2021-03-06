Utils = require '../../utils'
C = require('../../constants')
module.exports = (SelGenApp) ->
  SelGenApp.controller 'ItemSelController', ['$scope', '$rootScope', 'exportToJson', ($scope, $rootScope, exportToJson) ->
    exportToJson.registerItemSel(()->
      ret = []
      for selAttr in $scope.selAttributes
        ret.push(name: selAttr.name, type: selAttr.type, cssText: selAttr.cssText)
      return ret
    )

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
    data.elementBackup = {}
    data.elementBackup.css = { 'background-color': $(data.elements).css('background-color') }

    $scope.$watch('selAttr.cssText', (cssText) ->
      $(data.elements).css('background-color', data.elementBackup.css['background-color'])
      try
        data.elements = innerDocument.querySelectorAll(cssText)
        $(data.elements).css('background-color', $scope['selAttr'].backgroundColor)
      catch e
        # eat the exception because the user can input an invalid css selector
    )
    $scope.$watch('selAttr.backgroundColor', (color) ->
      $(data.elements).css('background-color', color)
    )
    $scope.onDelete = (index) ->
      $(data.elements).css('background-color', data.elementBackup.css['background-color'])
      $rootScope.$broadcast('ItemSelController::onDelete', index)
  ]

