createSvg = (d3, selector) ->

  margin = {
    top: 20,
    bottom: 20,
    left: 10
    right: 10,
  }

  elem = document.querySelector(selector)
  elemHeight = elem.offsetHeight
  elemWidth = elem.offsetWidth

  width = elemWidth - margin.left - margin.right
  height = elemHeight - margin.bottom - margin.top

  svg = d3.select(selector).append("svg")
    .attr("width", elemWidth)
    .attr("height", elemHeight)
    .append("g")
      .attr("transform", "translate(#{margin.left},#{margin.top})")

  [svg, width, height]

extractX = (d) -> d[0]
extractY = (d) -> d[1]
