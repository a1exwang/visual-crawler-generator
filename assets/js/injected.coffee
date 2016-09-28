ParserSelector = require './gen/parser'

##
# This file is injected in the client page.
#
# This file handles all intercepted DOM event and translate them into parser commands
#  and send to parser.js

## Interfaces
# selGen = new ParserSelector(document)
# selectors = selGen.parseOneElement(element)
# selectors is an array of Selector
#
# Selector:
#   functions:
#     toCSS()
#     toReadableString()
#
# selGen1 = selGen.createListSelectorGen(element)
# selGen2 = selGen1.parseNextElement(element)
# ...
# {cssText} = selGenN.getSelector()
#
# SelectorCreation event
# outerWindow.api.addSingleAttributeToElementSelector(cssText)
# outerWindow.api.addSingleAttributeToListSelector(cssText)

listSelGen = null

injectedJsWithJQuery = (window, $, outerWindow, outerDocument) ->
  outerWindow.w = outerWindow.innerWindow = window
  outerWindow.d = outerWindow.innerDocument = window.document
  document = window.document

  $.each $('*'), (i, docElement) ->
    jqElement = $(docElement)
    
    parseFirstElement = (event) ->
      selectorGen = new ParserSelector(docElement.ownerDocument)
      listSelGen = selectorGen.createListSelectorGen(docElement)

    parseNextElement = (event) ->
      listSelGen.parseNextElement(docElement)
      cssText = listSelGen.getCSS()
      elements = document.querySelectorAll(cssText)
      for selectedTarget in elements
        $(selectedTarget).stop().css("background-color", "#FFFF9C")

      outerWindow.api.addSingleAttributeToListSelector(cssText)

    parseOneElement = (event, level) ->
      return unless level == 0
      selectorGen = new ParserSelector(docElement.ownerDocument)
      selectors = selectorGen.parseOneElement(docElement)
      $.each(selectors, (i, selector) ->
        console.log "Selector##{i}: #{selector.toReadableString()}"

        selectorResult = document.querySelectorAll(selector.toCSS()) # selector(document)
        if selectorResult
          if selectorResult.length == 0
            console.log("bad selector, cannot select self")
          else if selectorResult.length == 1
            # we can determine that only one valid element is selected
            if selectorResult[0] == docElement
              console.log("good selector")
              console.log(docElement)
            else
              console.log("bad selector, cannot select itself")
          else
            console.log("multiple(#{selectorResult.length}) elements selected, selector not accurate enough:")
            $.each(selectorResult, (i, selectedElement) ->
              txt = $(selectedElement).text().trim()
              if txt.length > 30
                txt = txt.substr(0, 30) + "..."
              console.log(selectedElement.tagName + " \"#{txt}\"")
            )
        else
          console.log("selected nothing")

        outerWindow.api.addSingleAttributeToElementSelector(selector.toCSS())
#        console.log('------')
      )

      # call previous click event
      prevOnclick = jqElement.data('__prev_onclick')
      prevOnclick(event) if prevOnclick

      # call parent on click event
      parentMyOnClick = jqElement.parent().data('__my_onclick')
      if parentMyOnClick
        parentMyOnClick(event, level + 1)

    jqElement.data('__prev_onclick', jqElement.attr('onclick'))
    jqElement.data('__my_onclick', parseOneElement)
    jqElement.on('mousedown', (e) ->
      # Right mouse key clicked
      if e.which == 3
        if e.ctrlKey
          if listSelGen
            parseNextElement(e)
          else
            parseFirstElement(e)
        else if e.shiftKey
          listSelGen = null
        else
          parseOneElement(e, 0)
        e.stopPropagation()
    )

module.exports = injectedJsWithJQuery
