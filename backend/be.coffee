$ = require 'jquery'
fs = require 'fs'
jsdom = require 'jsdom'
request = require 'request'
util = require 'util'

json = JSON.parse(fs.readFileSync(__dirname + "/crawlers.json"))
crawlers = json['crawlers']

for crawler in crawlers
  for url in crawler.urls
    options = { uri: url, headers: crawlers.headers }
    request options, (err, response, body) ->
      if (err || response.statusCode != 200)
        console.log(err)
        console.log("HTTP status code = #{response.statusCode}")
        throw "request failed"
      else
        jsdom.env response.body, [], (err, window) ->
          jsdom.jQueryify window, "http://code.jquery.com/jquery.js", ->
            $ = window.$
            $(window.document).ready ->
              crawlingResults = []
              for attribute in crawler.attributes
                elements = window.document.querySelectorAll(attribute.css)
                if elements.length == 0
                  throw "invalid selector `#{attribute.css}`, selected nothing!"
                switch attribute.type
                  when 'text'
                    value = $(elements).text()
                  when 'link'
                    element = elements[0]
                    value = $(element).attr('href')
                  else
                    throw "Unknown type"
                crawlingResults.push(
                  name: attribute.name,
                  type: attribute.type,
                  css: attribute.css,
                  value: value
                )
              console.log crawlingResults


