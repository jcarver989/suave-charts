class Svg
  constructor: (selector, aspectRatio, @margin) ->
    [w, h] = aspectRatio.split(":")
    @aspectRatio = [parseInt(w), parseInt(h)]

    # allow users to pass in a node or a selector string
    @domElement = if typeof selector == "string"
      document.querySelector(selector)
    else
      selector

    @container = d3
      .select(@domElement)
      .append("svg")
      .attr('preserveAspectRatio','xMinYMin')

    @chart = @container.append("g")

   resize: (margin = @margin) ->
    [w, h] = [@domElement.offsetWidth, @domElement.offsetHeight]
    newHeight = w / @aspectRatio[0] * @aspectRatio[1]
    @width = w - margin.left - margin.right
    @height = newHeight - margin.bottom - margin.top

    @container
      .attr("width", w)
      .attr("height", newHeight)

    @chart.attr("transform", "translate(#{margin.left},#{margin.top})")

module.exports = Svg
