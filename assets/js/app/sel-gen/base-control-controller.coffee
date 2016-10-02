{dialog} = require('electron').remote
C = require('../../constants')
Utils = require('../../utils')
fs = require('fs')

module.exports = (SelGenApp) ->
  SelGenApp.controller 'BaseControlController', ['$scope', '$rootScope', 'exportToJson', ($scope, $rootScope, exportToJson) ->
    $scope.clickImport = () ->

    $scope.clickExport = () ->
      filePath = dialog.showSaveDialog()
      if filePath
        exportToJson.doExport(filePath)

  ]
