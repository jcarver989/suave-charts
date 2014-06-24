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
    circles = lines.selectAll("circle").data((line) ->
      data = []

      if line.dots != false
        for d in line.data
          d.label = line.label
          data.push(d)

      data
    )

    circles.
      transition()
      .delay(200)
      .attr("cx", (d) => @x(extractX(d)))
      .attr("cy", (d) => @y(extractY(d)))

    circles.enter().append("circle")
      .attr("class", (d) -> "dot #{d.label}")
      .attr("r", 5)
      .attr("cx", (d) => @x(extractX(d)))
      .attr("cy", (d) => @y(extractY(d)))

    circles.exit().remove()

  drawLines: (enter, update) ->
    enter
      .append("path")
      .attr("class", (d) -> "line #{d.label}")
      .attr("d", (d) => @line(d.data))

    update
      .select(".line")
      .transition()
      .delay(200)
      .attr("d", (d) => @line(d.data))

  drawAreas: (enter, update) ->
    enter
      .filter((d) -> d.area != false)
      .append("path")
      .attr("class", (d) -> "area #{d.label}")
      .attr("d", (d) => @area(d.data))

    update
      .filter((d) -> d.area != false)
      .select(".area")
      .transition()
      .delay(200)
      .attr("d", (d) => @area(d.data))

  draw: (lines) ->
    allPoints = (line.data for line in lines)
    flattened = d3.merge(allPoints)
    @x.domain d3.extent(flattened, extractX)
    @y.domain [0, d3.max(flattened, extractY)]

    @drawAxes()

    lines = @svg.selectAll(".lineGroup")
      .data(lines, (d) -> d.label)
    
    newLines = lines.enter().append("g")
      .attr("class", "lineGroup")

    lines.exit().remove()

    @drawLines(newLines, lines)
    @drawAreas(newLines, lines) if @options.area
    @drawCircles(lines, allPoints) if @options.dots

      

