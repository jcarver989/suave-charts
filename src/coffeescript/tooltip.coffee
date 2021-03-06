class Tooltip
  constructor: (doc) ->
    @cssClass = "suave-tooltip"
    node = doc.querySelector("." + @cssClass) || doc.createElement('div')
    @tip = d3.select(node)
    @tip.attr("class", @cssClass)
    doc.body.appendChild(@tip.node())

  html: (content) =>
    @tip.html(content)

  show: (node) =>
    offset = @offset(node)
    @tip.attr("class", "#{@cssClass} show")
    @tip.style({
      "position" : "absolute",
      "top" : "#{offset.top}px",
      "left" : "#{offset.left}px"
    })

  hide: () =>
    @tip.attr("class", @cssClass)

  remove: () =>
    @tip.remove()

  offset: (node) ->
    nodeCoords = node.getBoundingClientRect()
    nodeCenter = nodeCoords.left + ((nodeCoords.right - nodeCoords.left) / 2)

    tipCoords = @tip.node().getBoundingClientRect()
    tipWidth = tipCoords.right - tipCoords.left
    tipHeight = tipCoords.bottom - tipCoords.top

    scrollX = window.scrollX
    scrollY = window.scrollY

    { top: nodeCoords.top - (tipHeight + 10) + window.scrollY, left: nodeCenter - (tipWidth / 2) + window.scrollX }


module.exports = Tooltip
