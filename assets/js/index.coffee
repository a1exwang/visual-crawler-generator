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
        # NOTE: DO NOT use $apply here
        scope.$apply ->
          scope.url = $("#frame").get(0).contentWindow.location.toString()
        scope.onFrameLoad()
  }

loadAngularCtrl('./js/app/SelGen/AddressBarController', SelGenApp)
loadAngularCtrl('./js/app/SelGen/ListSelController', SelGenApp)
loadAngularCtrl('./js/app/SelGen/ItemSelController', SelGenApp)
loadAngularCtrl('./js/app/SelGen/FrameController', SelGenApp)

##
# Initialize with jQuery here.
$(document).ready ->
  frame = $("#frame")

  selectorCreator = require('./js/ui/dialogTable')(
    document.querySelector("#componentCreateListSelector"), # list selector table
    document.querySelector("#componentCreateItemSelector")  # item selector table
  )

  $("#inputUrlForm").on 'submit', (e) ->
    frame.setAttribute('src', $("#inputUrl").val())
    e.preventDefault()

  ##
  # Add other UI initialization here, especially with jQuery
  # ...

  ##
  # Expose the API of outer window,
  # so that inner window can use it to communicate with outer window.
  #
  # TODO, I know this way of using a global variable seems stupid,
  #   but it's the easiest way to do inter-window communication
  window.api = {
    addSingleAttributeToListSelector: (selectorText) ->
      selectorCreator.listSelectorAddEditableColumn('', selectorText)
    addSingleAttributeToElementSelector: (selectorText) ->
      selectedText = window.innerDocument.querySelectorAll(selectorText)[0].outerHTML
      selectorCreator.itemSelectorAddEditableColumn('', selectorText, selectedText)
  }


