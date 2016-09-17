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
  selectorCreator = require('./js/ui/dialogTable')(
    $("#componentCreateListSelector").get(0), # list selector table
    $("#componentCreateItemSelector").get(0)  # item selector table
  )

  window.api = {
    addSingleAttributeToListSelector: (selectorText) ->
      selectorCreator.listSelectorAddEditableColumn('', selectorText)
    addSingleAttributeToElementSelector: (selectorText) ->
      selectedText = window.innerDocument.querySelectorAll(selectorText)[0].outerHTML
      selectorCreator.itemSelectorAddEditableColumn('', selectorText, selectedText)
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



