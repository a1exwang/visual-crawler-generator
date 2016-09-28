require 'jquery'
positionSelectorGen = require './positionSelectorGen'

listSelectorGen = (itemElement, listElement) ->
  firstItemElement = listElement.children[0]
  cssSelector = positionSelectorGen(itemElement, listElement)
  cssSelector = cssSelector.split(" > ").slice(1).join(" > ")
  if cssSelector.length > 0
    firstItemElement.tagName.toLowerCase() + " > " + cssSelector
  else
    firstItemElement.tagName.toLowerCase()
module.exports = listSelectorGen