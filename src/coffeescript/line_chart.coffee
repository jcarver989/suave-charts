# TODOS:
# multi axis
# Bar charts
# transitions/animations

class LineChart extends AbstractChart
  constructor: (selector, options = {}) ->
    super(selector, options)
    # @line and @area are simply functions that know how to 
    # draw the SVG path's 'd' attribute. ex @line([[x, y], [x, y]]) => path string
    @line = d3.svg.line()
      .x(@scales.scaleX)
      .y(@scales.scaleY)

    @area = d3.svg.area()
      .x(@scales.scaleX)
      .y(@scales.scaleY)

    d3.select(window).on('resize', @render)

  enterLines: (enter) ->
    enter
      .append("path")
      .attr("class", (line) -> "line #{line.label}")

  enterAreas: (enter) ->
    enter
      .filter((line) -> line.area == true)
      .append("path")
      .attr("class", (line) -> "area #{line.label}")

  createTooltip: () ->
    tip = (@tip ||= new Tooltip(document))
    @dots.on("mouseover", (d) ->
      tip.html(d[1])
      tip.show(this))
    @dots.on("mouseout", (d) -> tip.hide())

  render: (isUpdate = true) =>
    @updateDimensions() if isUpdate
    @axes.draw(@svg.width, @svg.height)
    @lines.attr("d", (line) =>
      @line.interpolate(@chooseInterpolation(line))
      @line(line.data)
    )
    @area.y0(@svg.height)
    @areas.attr("d", (line) =>
      @area.interpolate(@chooseInterpolation(line))
      @area(line.data)
    )
    @dots
      .attr("cx", @scales.scaleX)
      .attr("cy", @scales.scaleY)

  chooseInterpolation: (line) -> if line.smooth then "monotone" else "linear"

  draw: (lines) ->
    allPoints = d3.merge((line.data for line in lines))
    @scales.setDomains(allPoints)

    # bind the line's data to the dom
    @lineGroups = @svg.chart
      .selectAll(".lineGroup")
      .data(lines, (line) -> line.label)

    newGroups = @lineGroups.enter()
      .append("g")
      .attr("class", "lineGroup")

    @enterLines(newGroups)
    @enterAreas(newGroups)
    @lines = @lineGroups.selectAll(".line")
    @areas = @lineGroups.selectAll(".area")

    
    # To ensure dots are not convered up by a line/area we
    # rebind all the data to .dotGroups and add them to the DOM
    # after everything else since SVG has no z-index 
    @dotGroups = @svg
      .chart
      .selectAll(".dotGroup")
      .data(lines, (line) -> line.label)

    @dotGroups.enter().append("g").attr("class", "dotGroup")
    @dots = @dotGroups
      .selectAll(".dot")
      .data((line) ->
        return [] if line.dots == false
        ([d[0], d[1], line.label] for d in line.data)
      )

    @dots.enter()
      .append("circle")
      .attr("class", (d) -> "dot #{d[2]}")
      .attr("r", @options.dotSize)

    @createTooltip() if @options.tooltips
    @render(false)
