# TODOS:
# multi axis
# Grouped bar charts
# Column charts
# transitions/animations

class LineChart extends AbstractChart
  constructor: (selector, options = {}) ->
    super(selector, defaultLineOptions, options)
    
    @x = Scales.fromString(@options.xScale)
    @y = Scales.fromString(@options.yScale)
    @axes = new Axes(@svg.chart, @x, @y, @options)

    @isTimeSeries = true if @options.xScale == "time"

    # check if user specified a label format like %y-%m-%d
    if @isTimeSeries && typeof @options.xLabelFormat == "string"
      @axes.xAxis.tickFormat(d3.time.format(@options.xLabelFormat))
    else
      @axes.xAxis.tickFormat(@options.xLabelFormat)

    @axes.yAxis.tickFormat(@options.yLabelFormat)
    @calc = new MarginCalculator(@svg)
    
    # @line and @area are simply functions that know how to 
    # draw the SVG path's 'd' attribute. ex @line([[x, y], [x, y]]) => path string
    @line = d3.svg.line()
    @area = d3.svg.area()
    
    window.addEventListener("resize", @render)

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
    format = @options.tooltipFormat
    @dots.on("mouseover", (pair) ->
      tip.html(format(pair.value))
      tip.show(this))
    @dots.on("mouseout", (d) -> tip.hide())

  render: () =>
    @svg.resize()
    @x.range([0, @svg.width])
    @y.range([@svg.height, 0])

    @axes.draw(@svg.width, @svg.height)
    @lines.attr("d", (line) =>
      @line.interpolate(@chooseInterpolation(line))
      @line(line.values)
    )
    @area.y0(@svg.height)
    @areas.attr("d", (line) =>
      @area.interpolate(@chooseInterpolation(line))
      @area(line.values)
    )
    @dots
      .attr("cx", (pair, i) => @x(@xLabels[i]))
      .attr("cy", (pair, i) => @y(pair.value))

  chooseInterpolation: (line) -> if line.smooth then "monotone" else "linear"

  #  chart.draw({ 
  #   labels: [...], // x-axis labels
  #   lines: [{ label: "", values: []}, ],
  # 
  #   line1: { values: [1, 2, 3...], area: true }, // normal line
  #   line2: { values: [null, 3, 4...], fillHoles: true  } // sparse line, ie missing values. The fillHoles option would interpolate between the missing points to draw a continuous line
  # })
  draw: (data) ->
    # if we have a time series and we get numbers for labels 
    # assume they are epoch times
    @xLabels = if @isTimeSeries && typeof data.labels[0] == "number"
      data.labels.map((l) -> new Date(l))
    else
      data.labels

    yValues = d3.merge((line.values for line in data.lines))
    @x.domain(d3.extent(@xLabels, (x) -> x)).nice()
    @y.domain([0, d3.max(yValues, (y) -> y)]).nice()

    @line
    .x((v, i) => @x(@xLabels[i]))
    .y((v) => @y(v))

    @area
    .x((v, i) => @x(@xLabels[i]))
    .y((v) => @y(v))

    # dynamically choose the left margin
    if @options.autoMargins
      @options.margin.left = @calc.calcLeftMargin(@axes.yAxis, @options.margin.left)

    # bind the line's data to the dom
    @lineGroups = @svg.chart
      .selectAll(".lineGroup")
      .data(data.lines, (line) -> line.label)

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
      .data(data.lines, (line) -> line.label)

    @dotGroups.enter().append("g").attr("class", "dotGroup")
    @dots = @dotGroups
      .selectAll(".dot")
      .data((line) ->
        return [] if line.dots == false
        ({value: v, label: line.label} for v in line.values)
      )

    @dots.enter()
      .append("circle")
      .attr("class", (pair) -> "dot #{pair.label}")
      .attr("r", @options.dotSize)

    @createTooltip() if @options.tooltips
    @render()
