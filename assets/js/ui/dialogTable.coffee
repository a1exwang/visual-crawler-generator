$ = require 'jquery'

dialogElement = null
addEditableColumn = (key, value) ->
  nextId = $("table", dialogElement).children().length
  $("table", dialogElement).append(
    """
      <tr>
        <td><input id="inputColumnKey#{nextId}" name="key#{nextId}" value="#{key}" /></td>
        <td><textarea id="inputColumnValue#{nextId}" name="selector#{nextId}">"#{value}"</textarea></td>
      </tr>
    """)

module.exports = (dlg) ->
  dialogElement = dlg
  return {
    addEditableColumn: addEditableColumn
  }