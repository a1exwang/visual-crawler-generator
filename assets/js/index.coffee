$ = require 'jquery'

##
# AngularJS App initialization
loadAngularCtrl = (filePath, app) ->
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

loadAngularCtrl('./js/app/SelGen/DummyController', SelGenApp)
loadAngularCtrl('./js/app/SelGen/AddressBarController', SelGenApp)
loadAngularCtrl('./js/app/SelGen/ListSelController', SelGenApp)
loadAngularCtrl('./js/app/SelGen/ItemSelController', SelGenApp)
loadAngularCtrl('./js/app/SelGen/FrameController', SelGenApp)

