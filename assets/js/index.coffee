$ = require 'jquery'
onInjected = require './js/injected'

loadJQueryAndInjectJs = (win, doc) ->
  script = doc.createElement("SCRIPT")
  previousJQuery = win.jQuery || win.$

  script.onload = ->
    newJQuery = win.jQuery.noConflict()
    win.jQuery = win.$ = previousJQuery
    onInjected(win, newJQuery)
  script.src = "https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"
  script.type = 'text/javascript';
  doc.getElementsByTagName("head")[0].appendChild(script)
#  checkReady = (callback) ->
#    if win.jQuery
#      console.log(win.jQuery.noConflict()(doc).on)
#      callback(win, win.jQuery)
#    else
#      win.setTimeout((-> checkReady(callback)), 100)
#  checkReady(onInjected)

$(document).ready ->

  $("#inputUrlForm").on 'submit', (e) ->
    frame.setAttribute('src', $("#inputUrl").val())
    e.preventDefault()

  frame = $("#frame")
  frame.on 'load', ->
    console.log("iframe loaded: #{frame.attr('src')}")
    innerWindow = frame.get(0).contentWindow
    console.log(innerWindow.document)
    loadJQueryAndInjectJs(innerWindow, innerWindow.document)


