module.exports = (window, document, $, crawlingResults, data, cb) ->
  $.each $("table.mg-b20 > tbody > tr"),(index, item) ->
    if(item.children.length == 2)
      leftElement = item.children[0]
      rightElement = item.children[1]
      attrName = $(leftElement).text().trim()
      type = null
      attrValue = null
      if rightElement.children.length == 0 and
         rightElement.childNodes.length == 1 and
         rightElement.childNodes[0].nodeName == "#text"

        # pure-text-element
        attrValue = $(rightElement).text().trim()
        type = "text"
      else if rightElement.children.length >= 1
        # array of elements
        attrValue = []
        type = null
        for child in rightElement.children
          if child.tagName == "A"
            attrValue.push(type: "link", name: $(child).text().trim(), url: child.getAttribute("href"))
            if type == null
              type = "linkArray"
            else if type != "linkArray"
              type = "array"
          else if child.tagName == "IMG"
            attrValue.push(type: "image", url: child.getAttribute("src"))
            if type == null
              type = "imageArray"
            else if type != "imageArray"
              type = "array"
          else
            type = "array"
            console.log("Unknown element: " + child)
      cb(name: attrName, value: attrValue, type: type, associatedElements: item) if type


