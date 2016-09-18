###
  One Selector Generator

  cssText = getAttrSelectorCSS(node)
  The generated selector will be like
  `div#id` or `div.a.b` or `div[name="haha"]`

  It is a level-1 selector.
###

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

module.exports = getAttrSelectorCSS

