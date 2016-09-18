$ = require 'jquery'
getAttrSelectorCSS = require './oneSelector'

###

  Position Selector Generator

  Usage:
  `cssSelectorText = positionSelectorGen(element, rootElement)`

  It will generate a selector like:
    `div:nth-child(1) > div:nth-child(2) > span:nth-child(3)`
  You can use `rootElement.querySelectorAll(cssSelectorText)` to get `element`

###

indexOfChild = (node, e) ->
  for ele, i in node.children
    if ele == e
      return i
  return -1

getDomAncestors = (domElement, rootElement) ->
  if rootElement == domElement
    return [rootElement]
  parent = domElement.parentElement
  if parent
    list = getDomAncestors(parent, rootElement)
    list.push(domElement)
    return list
  else
    throw "positionSelectorGen#getDomAncestors: rootElement is not an ancestor of docElement"

positionSelectorGen = (docElement, rootElement) ->
  rootElement ||= docElement.ownerDocument
  ancestors = getDomAncestors(docElement, rootElement)

  depth = 1
  parent = rootElement
  indexes = []
  while depth < ancestors.length
    child = ancestors[depth]
    indexes.push(
      index: indexOfChild(parent, child),
      tagName: child.tagName,
      node: child
    )
    parent = child
    depth++
  $.map(indexes, (item) -> "#{getAttrSelectorCSS(item.node)}:nth-child(#{item.index + 1})").join(" > ")

module.exports = positionSelectorGen
