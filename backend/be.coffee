$ = require 'jquery'
jsdom = require 'jsdom'
request = require 'request'

options = {
  url: 'http://www.dmm.com/digital/anime/-/detail/=/cid=5365hatsukoim00011/?i3_ref=list&i3_ord=1dmm.com/en/digital/anime/-/detail/=/cid=5365hatsukoim00011/?i3_ref=list&i3_ord=1',
  "headers": {
    "Accept-Language": "en-US",
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) visual-spider/0.1.0 Chrome/52.0.2743.82 Electron/1.3.5 Safari/537.36"
  }
}

request options, (err, response, body) ->
  if (!err && response.statusCode == 200)
    jsdom.env response.body, [], (err, window) ->
      jsdom.jQueryify window, "http://code.jquery.com/jquery.js", ->
        $ = window.$;
        $(window.document).ready ->
          result = window.document.querySelector(
            'html > body[name="dmm_main"] > table#w > tbody > tr > td#mu > div.page-detail > table.mg-b12 > tbody > tr > td > div.mg-b20.lh4 > dl.mg-t12.mg-b0.lh3 > dd.float-l.mg-l6 > a')
          console.log result.outerHTML
