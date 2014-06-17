class LineChart extends AbstractChart
  constructor: (selector, @options = {}) ->
    super(selector, options)

    @line = d3.svg.line()
      .x (d) => @x(extractX(d))
      .y (d) => @y(extractY(d))

    @area = d3.svg.area()
      .x (d) => @x(extractX(d))
      .y (d) => @y(extractY(d))
      .y0(@height)

  drawCircles: (lines, data) ->
    circles = lines.selectAll("circle").data((d) -> d.data)

    circles.
      transition()
      .delay(200)
      .attr("cx", (d) => @x(extractX(d)))
      .attr("cy", (d) => @y(extractY(d)))

    circles.enter().append("circle")
      .attr("class", "dot")
      .attr("fill", (d, i) -> colors[i % colors.length])
      .attr("r", 5)
      .attr("cx", (d) => @x(extractX(d)))
      .attr("cy", (d) => @y(extractY(d)))

    circles.exit().remove()

  drawLines: (enter, update) ->
    enter
      .append("path")
      .attr("class", "line")
      .attr("stroke", (d, i) -> colors[i % colors.length])
      .attr("d", (d) => @line(d.data))

    update
      .select(".line")
      .transition()
      .delay(200)
      .attr("d", (d) => @line(d.data))

  drawAreas: (enter, update) ->
    enter
      .append("path")
      .attr("class", "area")
      .attr("fill", (d, i) -> "rgba(0,0,0,.1)")
      .attr("d", (d) => @area(d.data))

    update
      .select(".area")
      .transition()
      .delay(200)
      .attr("d", (d) => @area(d.data))


  draw: (lines) ->
    data = (line.data for line in lines)
    flattened = d3.merge(data)

    @x.domain d3.extent(flattened, extractX)
    @y.domain [0, d3.max(flattened, extractY)]

    @drawAxes()

    lines = @svg.selectAll(".lineGroup")
      .data(lines, (d) -> d.label)
    
    newLines = lines.enter().append("g")
      .attr("class", "lineGroup")

    lines.exit().remove()

    @drawLines(lines, newLines)
    @drawAreas(lines, newLines) if @options.area
    @drawCircles(lines, data) if @options.dots 

      

