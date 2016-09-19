{app, BrowserWindow} = require 'electron'

win = null;
createWindow = ->
  win = new BrowserWindow(
    width: 1440,
    height: 900,
    'web-preferences': {
      'web-security': false,
      'experimental-features' : true
    }
  )
  win.loadURL("file://#{__dirname}/../assets/index.html")
  win.webContents.openDevTools()
  win.on('closed', -> win = null)

app.on 'ready', createWindow
app.on 'window-all-closed', ->
  if (process.platform != 'darwin')
    app.quit()

app.on 'activated', ->
  if (win == null)
    createWindow()

