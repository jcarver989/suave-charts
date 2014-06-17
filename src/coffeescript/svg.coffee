createSvg = (d3, selector) ->
  elem = document.querySelector(selector)
  elemWidth = elem.offsetWidth
  elemHeight = elem.offsetHeight
  padding = 80

  svg = d3.select(selector).append("svg")
    .attr('viewBox',"0 0 #{elemWidth} #{elemHeight}" )
    .attr('preserveAspectRatio','xMinYMin')
    .attr("width", "100%")
    .attr("height", "100%")
    .append("g")
      .attr("transform", "translate(" + padding / 2 + "," + padding / 2 + ")")

  [svg, elemWidth - padding, elemHeight - padding]


extractX = (d) -> d[0]
extractY = (d) -> d[1]
