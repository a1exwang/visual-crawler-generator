$ = require 'jquery'

traverseAncestors = (node, cb) ->
  if node.parentNode
    depth = traverseAncestors(node.parentNode, cb) + 1
    cb(node, depth)
  else
    return 0

module.exports = (node) ->
  tagNames = []
  traverseAncestors(node, (ancestor, depth) ->
    tagNames.push(ancestor.tagName)
  )

  tagNames.join(">")


