$ = require('jquery')
tagSelectorGen = require './tagSelectorGen'
positionSelectorGen = require './positionSelectorGen'
listSelectorGen = require './listSelectorGen'

createCSSSelector = (cssText, score) ->
  selector = (document) ->
    document.querySelectorAll(selector.cssText)
  selector.cssText = cssText
  selector.score = score
  selector.toReadableString = ->
    return "CSS <#{score}> \"#{selector.cssText}\""
  selector.toCSS = ->
    return selector.cssText
  selector.getScore = ->
    return selector.score
  return selector

getDomAncestors = (domElement) ->
  parent = domElement.parentElement
  if parent
    list = getDomAncestors(parent)
    list.push(domElement)
    return list
  else
    return []

indexOfChild = (node, e) ->
  for ele, i in node.children
    if ele == e
      return i
  return -1

getNodeByIndexes = (node, indexes) ->
  try
    for index in indexes[1...indexes.length]
      node = node.children[index]
    return node
  catch e
    console.log(e)
    return null

ParserSelector = (document) ->
  thisOfParserSelector = this
  this.document = document
  this.getItemSelectors = (domElement) ->
    selectors = []
    cssText = null
    if $(domElement).attr('id')
      cssText = domElement.tagName.toLowerCase() + "##{$(domElement).attr('id')}"
      score = 100
    else if $(domElement).attr('name')
      name = $(domElement).attr('name')
      cssText = "[name=\"#{name}\"]"
      score = 50
    else if $(domElement).attr('class')
      classNames = $(domElement).attr('class').trim().split(/\s+/)
      cssText = domElement.tagName.toLowerCase() + $.map(classNames, (ele) -> "." + ele).join('')
      score = 10

    if cssText
      selectors.push(createCSSSelector(cssText, score))
    return selectors

  this.selectListElementsWithTwoDomElements = (firstDomElement, secondDomElement) ->
    ancestors1 = getDomAncestors(firstDomElement)
    ancestors2 = getDomAncestors(secondDomElement)
    i = 0
    while true
      if i >= ancestors1.length || i >= ancestors2.length
        i = -1
        break
      if ancestors1[i] != ancestors2[i]
        i--
        break
      i++

    if i == -1
      throw "cannot found common ancestor"
    else
      commonAncestor = ancestors1[i]

    # we have common_ancestor
    cssCommonAncestorSelector = tagSelectorGen(commonAncestor)
    cssListItemSelector = listSelectorGen(firstDomElement, commonAncestor)

    console.log "ListNode selector: \"" + cssCommonAncestorSelector + '"'
    console.log document.querySelectorAll(cssCommonAncestorSelector)
    console.log "Elements selector: \"" + cssListItemSelector + '"'
    console.log commonAncestor.querySelectorAll(cssListItemSelector)

    # get indexes
    iGeneration = i + 1
    node = commonAncestor
    indexes = []
    while iGeneration < ancestors1.length
      indexes.push indexOfChild(node, ancestors1[iGeneration])
      node = ancestors1[iGeneration]
      iGeneration++

    selectedTargets = $.map(commonAncestor.children, (e) -> getNodeByIndexes(e, indexes))

    return selectedTargets

  this.createListSelectors = (firstDomElement) ->
    listSelector = (nextDomElement) ->
      listSelector.domElements.push(nextDomElement)
      if listSelector.domElements.length == 2
        elements = thisOfParserSelector.selectListElementsWithTwoDomElements(firstDomElement, nextDomElement)
        return elements
      else
        # verify parent node
        console.log("should verify parent")

    listSelector.domElements = [firstDomElement]
    return listSelector

  return this
module.exports = ParserSelector
