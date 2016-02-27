AbstractChart = require('./abstract_chart')
Axes = require('./axes')
MarginCalculator = require('./margin_calculator')
Scales = require('./scales')
Tooltip = require('./tooltip')
defaultLineOptions = require('./defaults').lineOptions

class LineChart extends AbstractChart
  constructor: (selector, options = {}) ->
    super(selector, defaultLineOptions, options)
    @x = Scales.fromString(@options.xScale)
    @y = Scales.fromString(@options.yScale)
    @axes = new Axes(@svg.chart, @x, @y, @options, @axisLabelPadding)

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
    @line = d3.svg.line().defined((d) -> d.y != null)
    @area = d3.svg.area().defined((d) -> d.y != null)

  enterLines: (enter) ->
    enter
      .filter((line) -> line.line != false)
      .append("path")
      .attr("class", (line, i) -> "line")

  enterAreas: (enter) ->
    enter
      .filter((line) -> line.area == true)
      .append("path")
      .attr("class", (line, i) -> "area")

  createTooltip: () ->
    tip = (@tip ||= new Tooltip(document))
    format = @options.tooltipFormat
    @dots.on("mouseover", (point) ->
      tip.html(format(point.y))
      tip.show(this))
    @dots.on("mouseout", (d) -> tip.hide())

  render: () =>
    @svg.resize()
    if @options.xScale == "ordinal"
      @x.rangePoints([0, @svg.width])
    else
      @x.range([0, @svg.width])

    @y.range([@svg.height, 0])

    @axes.draw(@svg.width, @svg.height)
    @lines.attr("d", (line) =>
      @line.interpolate(@chooseInterpolation(line))
      @line(line.values)
    )

    @areas.attr("d", (line) =>
      @area.interpolate(@chooseInterpolation(line))
      @area(line.values)
    )
    
    @dots
      .attr("cx", (point) => @x(point.x))
      .attr("cy", (point) => @y(point.y + point.baseline))

  chooseInterpolation: (line) -> if line.smooth then "monotone" else "linear"

  formatData: (data, stack = false) ->
    labels = if @isTimeSeries && typeof data.labels[0] == "number"
      data.labels.map((l) -> new Date(l))
    else
      data.labels

    xMin = null
    xMax = null
    yMax = null
    yMin = null
    
    lineCopies = []
    for line, i in data.lines
      lineCopies.push({ values: new Array(line.values.length) })
      for key, val of line when key != "values"
        lineCopies[i][key] = val

    for label, i in labels
      baseline = 0
      for line, j in data.lines
        y = line.values[i]
        yb = y + baseline
        xMin = label if !xMin? || xMin > label
        xMax = label if !xMax? || xMax < label
        yMin = yb if !yMin? || yMin > yb
        yMax = yb if !yMax? || yMax < yb
        copy = lineCopies[j]
        copy.values[i] = { x: label, y: y, baseline: baseline, lineKey: line.label }
        baseline += y if stack

    yStart = if @options.yScale == "log" then yMin else 0
    {
      labels: labels
      lines: lineCopies
      xDomain: [xMin, xMax]
      yDomain: [yStart, yMax]
    }

  draw: (data) ->
    super()
    { labels, lines, xDomain, yDomain } = @formatData(data, @options.stack)

    if @options.xScale == "ordinal"
      @x.domain(labels)
    else
      @x.domain(xDomain)

    @y.domain(yDomain).nice()

    @line
    .x((d) => @x(d.x))
    .y((d) => @y(d.y + d.baseline))

    @area
    .x((d) => @x(d.x))
    .y0((d) => @y(d.baseline))
    .y1((d) => @y(d.y + d.baseline))

    # dynamically choose the left margin
    if @options.autoMargins
      @options.margin.left = @calc.calcLeftMargin(@axes.yAxis, @options.margin.left)

    # bind the line's data to the dom
    @lineGroups = @svg.chart
      .selectAll(".line")
      .data(lines, (line) -> line.label)

    newGroups = @lineGroups.enter()
      .append("g")
      .attr("class", (line, i) -> "lineGroup line-#{i} #{line.label}")

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

    @dotGroups.enter().append("g").attr("class", (line, i) ->  "dotGroup line-#{i} #{line.label}")
    @dots = @dotGroups
      .selectAll(".dot")
      .data((line) =>
        return [] if line.dots == false
        line.values
      )

    @dots
      .enter()
      .append("circle")
      .filter((d) -> d.y != null)
      .attr("class", (point) -> "dot")
      .attr("r", @options.dotSize)

    @createTooltip() if @options.tooltips
    @render()

module.exports = LineChart
