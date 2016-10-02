fs = require 'fs'
module.exports = (SelGenApp) ->
  SelGenApp.factory('exportToJson', ['$window', ($window) ->
    data = {}
    service = {
      registerItemSel: (cb) ->
        data['item-sel'] = cb
      registerCustomSel: (cb) ->
        data['custom-sel'] = cb
      doExport: (filePath) ->
        json = {
          "name": "dmm",
          "urls": ["http://www.dmm.com/digital/anime/-/detail/=/cid=5365hatsukoim00011/?i3_ref=list&i3_ord=1dmm.com/en/digital/anime/-/detail/=/cid=5365hatsukoim00011/?i3_ref=list&i3_ord=1"],
          "headers": {
            "Accept-Language": "en-US",
            "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) visual-spider/0.1.0 Chrome/52.0.2743.82 Electron/1.3.5 Safari/537.36"
          },
          "attributes": [],
          "customScripts": []
        }
        if data['item-sel']
          for item in data['item-sel']()
            json.attributes.push(name: item.name, type: item.type, css: item.cssText)
        if data['custom-sel']
          for customScript in data['custom-sel']()
            json.customScripts.push(type: "code", code: customScript.code)
        console.log(json)
        fs.writeFileSync(filePath,JSON.stringify(json))
    }
    return service
  ])
