{dialog} = require('electron').remote
C = require('../../constants')
Utils = require('../../utils')
fs = require('fs')

module.exports = (SelGenApp) ->
  SelGenApp.controller 'CustomSelController', ['$scope', '$rootScope', 'exportToJson', ($scope, $rootScope, exportToJson) ->
    exportToJson.registerCustomSel(() ->
      if not $scope.filePath
        throw "you have not imported a js file"
      scriptContent = new String(fs.readFileSync($scope.filePath))
      return [{code: scriptContent}]
    )
    $scope.selAttributes = []
    $scope.clickImportCustomSelector = (e) ->
      console.log("clicked")
      filePaths = dialog.showOpenDialog(
        title: "Choose a javascript file",
        properties: ['openFile'],
        filters: [{name: 'Javascript files', extensions: ['js']}],
        defaultPath: "./backend/attrs"
      )

      if filePaths?.length != 1
        throw "openDialog returns less than or more than 1 file paths"

      filePath = filePaths[0]

      $scope.filePath = filePath
      $scope.fn = fn = require(filePath)
      fn(innerWindow, innerDocument, innerWindow.$, [], {}, (item) ->
        $scope.selAttributes.push(
          name: item.name,
          value: item.value,
          type: item.type,
          elements: item.associatedElements,
          backgroundColor: C.Colors[Utils.randInt(0, C.Colors.length)]
        )
      )
      return null
  ]
  SelGenApp.controller 'CustomSelItemController', ['$scope', '$rootScope', ($scope, $rootScope) ->
    $scope.selTypes = [
      { name: 'text', displayName: 'Text' },
      { name: 'image', displayName: 'Image' }
    ]
    data = $scope['selAttr']
    data.elementBackup = {}
    data.elementBackup.css = { 'background-color': $(data.elements).css('background-color') }

    $scope.$watch('selAttr.backgroundColor', (color) ->
      $(data.elements).css('background-color', color)
    )
    $scope.onDelete = (index) ->
      $(data.elements).css('background-color', data.elementBackup.css['background-color'])
      $rootScope.$broadcast('ItemSelController::onDelete', index)

  ]
