C = require('../../constants')
module.exports = (SelGenApp) ->
  SelGenApp.controller 'DummyController', ['$scope', '$rootScope', ($scope, $rootScope) ->
    ##
    # Expose the API of outer window,
    # so that inner window can use it to communicate with outer window.
    #
    # TODO, I know this way of using a global variable seems stupid,
    #   but it's the easiest way to do inter-window communication

    window.api = {
      addSingleAttributeToListSelector: (selectorText) ->
#        selectorCreator.listSelectorAddEditableColumn('', selectorText)
        $rootScope.$broadcast(C.Broadcasts.ListSel.AddSingleAttr,
          attributeName: '',
          selectorText: selectorText)
      addSingleAttributeToElementSelector: (selectorText) ->
        $rootScope.$broadcast(C.Broadcasts.ItemSel.AddSingleAttr, selectorText)
    }

    # NOTE initialize with jQuery only in here.
    $(document).ready ->
      $("#inputUrlForm").on 'submit', (e) ->
        $rootScope.$broadcast(C.Broadcasts.Frame.LoadUrl, $("#inputUrl").val())
        e.preventDefault()
#      webView = document.getElementById("frame")
#      webView.addEventListener "did-get-response-details", (details) ->
#        console.log(details)
  ]


