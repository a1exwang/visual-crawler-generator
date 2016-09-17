$ = require 'jquery'
onInjected = require './js/injected'

loadJQueryAndInjectJs = (win, doc) ->
  script = doc.createElement("SCRIPT")
  previousJQuery = win.jQuery || win.$

  script.onload = ->
    newJQuery = win.jQuery.noConflict()
    win.jQuery = win.$ = previousJQuery
    onInjected(win, newJQuery, window, document)
  script.src = "https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"
  script.type = 'text/javascript';
  doc.getElementsByTagName("head")[0].appendChild(script)

$(document).ready ->
  dialog = require('./js/ui/dialogTable')($("#dialogCreateSelectors").get(0))
  window.api = {
    addSingleAttribute: (selectorText) ->
      dialog.addEditableColumn('', selectorText)
  }

  $("#inputUrlForm").on 'submit', (e) ->
    frame.setAttribute('src', $("#inputUrl").val())
    e.preventDefault()

  frame = $("#frame")
  frame.on 'load', ->
    console.log("iframe loaded: #{frame.attr('src')}")
    innerWindow = frame.get(0).contentWindow
    console.log(innerWindow.document)
    loadJQueryAndInjectJs(innerWindow, innerWindow.document)



