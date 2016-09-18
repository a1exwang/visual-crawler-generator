$ = require 'jquery'
getAttrSelectorCSS = require './oneSelector'

traverseAncestors = (node, cb) ->
  if node.parentNode
    depth = traverseAncestors(node.parentNode, cb) + 1
    cb(node, depth)
  else
    return 0

module.exports = (node) ->
  tagNames = []
  traverseAncestors(node, (ancestorNode, _depth) ->
    extCss = getAttrSelectorCSS(ancestorNode)
    tagNames.push(ancestorNode.tagName.toLowerCase() + extCss)
  )

  tagNames.join(" > ")


