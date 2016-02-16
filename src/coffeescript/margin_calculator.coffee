# Calculates a safe left margin by rendering 
# a hidden axis into the DOM, finding the largest Y label
# and measuring its length. Since the user can specify custom
# CSS font rules, this is the only way to get reliable sizes
class MarginCalculator
  constructor: (@svg) ->

  calcLeftMargin: (yAxis, defaultMargin, minimumMargin = 20) ->
    fauxSelection = @svg.chart
      .append("g")
      .attr("class", "y axis")
      .attr("opacity", 0)

    fauxSelection.call(yAxis)
    texts = fauxSelection.selectAll("text").sort((a,b) -> b - a)
    margin = if (texts.length >= 1 && texts[0].length >= 1)
      bbox = texts[0][0].getBBox()
      Math.round(bbox.width) + minimumMargin
    else
      defaultMargin

    fauxSelection.remove()
    margin

module.exports = MarginCalculator
