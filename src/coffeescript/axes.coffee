class Axes
  constructor: (svg, scales, @options) ->
    @xAxisSelection = svg.append("g")
      .attr("class", "x axis")

    @yAxisSelection = svg.append("g")
      .attr("class", "y axis")

    @xAxis = @newAxis(scales.x, "bottom")
    @yAxis = @newAxis(scales.y, "left")

  draw: (width, height) ->
    @xAxisSelection.attr("transform", "translate(0,#{height})")

    if @options.grid
      @xAxis.tickSize(-height)
      @yAxis.tickSize(-width)

    if @options.xTickInterval
      ticks = switch @options.xTickInterval
        when "seconds" then d3.time.seconds
        when "minutes" then d3.time.minutes
        when "hours" then d3.time.hours
        when "days" then d3.time.days
        when "months" then d3.time.months
        when "years" then d3.time.years
      @xAxis.ticks(ticks)

    else if @options.ticks? && @options.ticks > 0
      @xAxis.ticks(@options.ticks)

    if @options.xTickFormat
      @xAxis.tickFormat(d3.time.format(@options.xTickFormat))

    @xAxisSelection.call @xAxis
    @yAxisSelection.call @yAxis

  newAxis: (scale, orientation) ->
    d3.svg.axis()
      .scale(scale)
      .orient(orientation)
      .tickPadding(@options.tickPadding)
