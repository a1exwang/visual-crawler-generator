$ = require 'jquery'

listSelectorElement = null
itemSelectorElement = null
addEditableColumn = (key, value) ->
  nextId = $("table", listSelectorElement).children().length
  $("table", listSelectorElement).append(
    """
      <tr>
        <td><input id="inputColumnKey#{nextId}" name="key#{nextId}" value="#{key}" /></td>
        <td><textarea id="inputColumnValue#{nextId}" name="selector#{nextId}">#{value}</textarea></td>
      </tr>
    """)

itemSelectorAddEditableColumn = (key, value, selectedText) ->
  nextId = $("table", itemSelectorElement).children().length
  $("table", itemSelectorElement).append(
    """
      <tr>
        <td><input id="inputColumnKey#{nextId}" name="key#{nextId}" value="#{key}" /></td>
        <td><textarea id="inputColumnValue#{nextId}" name="selector#{nextId}">#{value}</textarea></td>
        <td><textarea id="inputColumnSelectedText#{nextId}" name="selectedText#{nextId}" >#{selectedText}</textarea></td>
        <td><select>
          <option>Text</option>
          <option>Link</option>
          <option>Image</option>
          <option>List of Text</option>
        </select></td>
        <td><button>Delete</button></td>
      </tr>
    """)


module.exports = (listSel, itemSel) ->
  listSelectorElement = listSel
  itemSelectorElement = itemSel
  return {
    listSelectorAddEditableColumn: addEditableColumn,
    itemSelectorAddEditableColumn: itemSelectorAddEditableColumn
  }