$ = require 'jquery'

traverseAncestors = (node, cb) ->
  if node.parentNode
    depth = traverseAncestors(node.parentNode, cb) + 1
    cb(node, depth)
  else
    return 0

getAttrSelectorCSS = (node) ->
  cssText = ''
  if node.getAttribute('id')
    cssText = '#' + node.getAttribute('id')
  else if node.getAttribute('name')
    name = node.getAttribute('name')
    cssText = "[name=\"#{name}\"]"
  else if node.getAttribute('class')
    classNames = node.getAttribute('class').trim().split(/\s+/)
    cssText = '.' + classNames.join('.')
  return cssText

module.exports = (node) ->
  tagNames = []
  traverseAncestors(node, (ancestorNode, _depth) ->
    extCss = getAttrSelectorCSS(ancestorNode)
    tagNames.push(ancestorNode.tagName.toLowerCase() + extCss)
  )

  tagNames.join(" > ")


