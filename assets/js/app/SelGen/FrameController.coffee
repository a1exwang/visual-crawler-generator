C = require('../../constants')
toastr = require('toastr')
onInjected = require '../../injected'

###
  FrameController is an angular controller.
  It controls the iframe element.
###

##
# Load jQuery for inner window `win` and then execute our onInjected js function
loadJQueryAndInjectJs = (win, doc, outerWin, outerDoc, onInjected) ->
  script = doc.createElement("SCRIPT")
  previousJQuery = win.jQuery || win.$

  script.onload = ->
    newJQuery = win.jQuery.noConflict()
    win.jQuery = win.$ = previousJQuery
    onInjected(win, newJQuery, outerWin, outerDoc)

  script.src = "https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"
  script.type = 'text/javascript';
  doc.getElementsByTagName("head")[0].appendChild(script)

module.exports = (SelGenApp) ->
  SelGenApp.controller 'FrameController', ['$scope', '$window', '$rootScope', ($scope, $window, $rootScope) ->
    ##
    # $scope.woUrl is a write-only scope variable, read from it will cause undetermined behavior.
    # Read from `$scope.url` instead.
    # http://search.jd.com/Search?keyword=ddr4&enc=utf-8&wq=ddr4&pvid=2yc7vvsi.6924lg
    # http://www.dmm.com/en/digital/anime/-/list/=/sort=date/
    # http://www.dmm.com/en/digital/anime/-/detail/=/cid=5365hatsukoim00011/?i3_ref=list&i3_ord=1
    $scope.woUrl = 'http://www.dmm.com/en/digital/anime/-/list/=/sort=date/'
    $scope.onFrameLoad = ->
      innerWindow = $window.document.getElementById('frame').contentWindow
      $rootScope.$broadcast('urlChanged', $scope.url)
      console.log("iframe loaded: #{$scope.url}")
      toastr.info("iframe loaded: #{$scope.url}")
      loadJQueryAndInjectJs(innerWindow, innerWindow.document, $window, $window.document, onInjected)
      return

    $rootScope.$on(C.Broadcasts.Frame.LoadUrl, (event, url) ->
      $scope.$apply ->
        $scope.woUrl = url
    )
  ]

