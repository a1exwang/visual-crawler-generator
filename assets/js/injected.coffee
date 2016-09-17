ParserSelector = require './gen/parser'

listSelector = null

injectedJsWithJQuery = (window, $, outerWindow, outerDocument) ->
  outerWindow.w = outerWindow.innerWindow = window
  outerWindow.d = outerWindow.innerDocument = window.document
  document = window.document

  $.each $('*', ), (i, docElement) ->
    jqElement = $(docElement)

    parseFirstElement = (event) ->
      selectorGen = new ParserSelector(docElement.ownerDocument)
      listSelector = selectorGen.createListSelectors(docElement)

    parseNextElement = (event) ->
      {elements, selector} = listSelector(docElement)
      for selectedTarget in elements
        $(selectedTarget).stop().css("background-color", "#FFFF9C").animate({ backgroundColor: "#FFFFFF"}, 1500);

      outerWindow.api.addSingleAttributeToListSelector(selector)

    parseOneElement = (event, level) ->
      return unless level == 0
      selectorGen = new ParserSelector(docElement.ownerDocument)
      selectors = selectorGen.getItemSelectors(docElement)
#      console.log("--- Level #{level} ---")
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
      if e.which == 3
        if e.ctrlKey
          if listSelector
            parseNextElement(e)
          else
            parseFirstElement(e)
        else if e.shiftKey
          listSelector = null
        else
          parseOneElement(e, 0)
        e.stopPropagation()
    )

module.exports = injectedJsWithJQuery
