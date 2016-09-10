require 'jquery'
positionSelectorGen = require './positionSelectorGen'

listSelectorGen = (itemElement, listElement) ->
  firstItemElement = listElement.children[0]
  cssSelector = positionSelectorGen(itemElement, firstItemElement)
  firstItemElement.tagName.toLowerCase() + " > " + cssSelector

module.exports = listSelectorGen