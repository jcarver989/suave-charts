filterTicks = require('./filter_ticks')

class Axes
  constructor: (svg, @xScale, @yScale, @options, @axisLabelPadding) ->
    @xAxisSelection = svg.append("g")
      .attr("class", "x axis")

    @yAxisSelection = svg.append("g")
      .attr("class", "y axis")

    @xAxis = @newAxis(@xScale, "bottom")
    @yAxis = @newAxis(@yScale, "left")
  
  draw: (width, height) ->
    @xAxisSelection.attr("transform", "translate(0,#{height})")

    if @options.grid
      @xAxis.tickSize(-height, 0)
      @yAxis.tickSize(-width, 0)

    if @options.xLabelInterval
      ticks = switch @options.xLabelInterval
        when "seconds" then d3.time.seconds
        when "minutes" then d3.time.minutes
        when "hours" then d3.time.hours
        when "days" then d3.time.days
        when "months" then d3.time.months
        when "years" then d3.time.years

      step = if @options.tickStepSize? then @options.tickStepSize else 1
      @xAxis.ticks(ticks, step)

    else if @options.ticks? && @options.ticks > 0
      ticks = filterTicks(@options.ticks, @xScale, @options.xScale)
      @xAxis.tickValues(ticks)

    @yAxis.ticks(@options.yTicks)
    @xAxisSelection.call @xAxis
    @yAxisSelection.call @yAxis

  newAxis: (scale, orientation) =>
    d3.svg.axis()
      .scale(scale)
      .orient(orientation)
      .tickPadding(@axisLabelPadding)

module.exports = Axes
