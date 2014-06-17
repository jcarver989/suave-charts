class ScatterPlot extends AbstractChart
  constructor: (selector, options = {}) ->
    super(selector, options)

  draw: (data) ->
    @x.domain d3.extent(data, extractX)
    @y.domain [0, d3.max(data, extractY)]

    @drawAxes()

    circles = @svg.selectAll("circle").data(data)

    circles.enter().append("circle")
      .attr("class", "circle")
      .attr("fill",  (d, i) -> colors[i % colors.length])
      .attr("r", 5)
      .attr("cx", (d) => @x(extractX(d)))
      .attr("cy", (d) => @y(extractY(d)))

    circles.exit().remove()

