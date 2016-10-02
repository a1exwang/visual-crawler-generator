##
# AngularJS App initialization
loadAngularFile = (filePath, app) ->
  require(filePath)(app)

SelGenApp = angular.module('SelGenApp', [])
SelGenApp.config ($logProvider) ->
  $logProvider.debugEnabled(true)
SelGenApp.config ($sceDelegateProvider) ->
    $sceDelegateProvider.resourceUrlWhitelist(['**'])

# This is a dummy angular onload event directive for iframe
SelGenApp.directive 'onFrameLoad', ->
  return {
    restrict: 'A',
    scope: false, # disable scope isolating so we can modify the scope.
    link: (scope, element, attrs) ->
      element.on 'load', ->
        scope.$apply ->
          scope.url = document.getElementById("frame").contentWindow.location.toString()
        scope.onFrameLoad()
  }

loadAngularFile('./js/app/sel-gen/export-service', SelGenApp)
loadAngularFile('./js/app/sel-gen/address-bar-controller', SelGenApp)
loadAngularFile('./js/app/sel-gen/base-control-controller', SelGenApp)
loadAngularFile('./js/app/sel-gen/custom-sel-controller', SelGenApp)
loadAngularFile('./js/app/sel-gen/dummy-controller', SelGenApp)
loadAngularFile('./js/app/sel-gen/frame-controller', SelGenApp)
loadAngularFile('./js/app/sel-gen/item-sel-controller', SelGenApp)
loadAngularFile('./js/app/sel-gen/list-sel-controller', SelGenApp)

