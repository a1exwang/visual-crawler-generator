{remote} = require('electron')
{Menu} = remote

initContextMenu = (window) ->
  template = [
    {
      label: 'test',
      click: (->
        console.log(123)
        window.alert("hello")
      )
    }
  ]
  menu = Menu.buildFromTemplate(template)

  window.addEventListener('contextmenu', ((e) ->
    e.preventDefault()
    menu.popup(remote.getCurrentWindow())
  ), false)

module.exports = initContextMenu

