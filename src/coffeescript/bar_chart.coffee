AbstractChart = require('./abstract_chart')
MarginCalculator = require('./margin_calculator')
Tooltip = require('./tooltip')
defaultBarOptions = require('./defaults').barOptions
filterTicks = require('./filter_ticks')

class BarChart extends AbstractChart
  constructor: (selector, options = {}) ->
    super(selector, defaultBarOptions, options)
    @calc = new MarginCalculator(@svg)
    @x = d3.scale.ordinal()
    @groupedX = d3.scale.ordinal()
    @y = d3.scale.linear()

    @xAxis = d3.svg.axis()
      .scale(@x)
      .tickFormat(@options.xLabelFormat)
      .outerTickSize(0)
      .tickPadding(@axisLabelPadding)

    @yAxis = d3.svg.axis()
      .scale(@y)
      .tickFormat(@options.yLabelFormat)
      .tickPadding(@axisLabelPadding)

    if @options.layout == "vertical"
      @xAxis.orient("bottom")
      @yAxis.orient("left")
    else
      @xAxis.orient("left")
      @yAxis.orient("bottom")

  render: () =>
    @svg.resize()

    layout = if @options.layout == "vertical"
      @yAxis.tickSize(-@svg.width, 0) if @options.grid

      {
       xTransform: "translate(0, #{@svg.height})",
       yTransform: "",
       groupsTransform: (label) => "translate(#{@x(label)}, 0)",
       xRange: [0, @svg.width],
       yRange: [@svg.height, 0],
       barX: (barValue, i) => @groupedX(i),
       barY: (barValue) => @y(barValue),
       barWidth: () => @groupedX.rangeBand(),
       barHeight: (barValue) => @svg.height - @y(barValue)
      }
    else
      @yAxis.tickSize(-@svg.height, 0) if @options.grid
      {
       xTransform: "",
       yTransform: "translate(0, #{@svg.height})",
       groupsTransform: (label) => "translate(0, #{@x(label)})",
       xRange: [0, @svg.height],
       yRange: [0, @svg.width],
       barX: (barValue) => 0,
       barY: (barValue, i) => @groupedX(i),
       barHeight: () => @groupedX.rangeBand(),
       barWidth: (barValue) => @y(barValue)
      }

    @x.rangeRoundBands(layout.xRange, .1)
    @groupedX.rangeRoundBands([0, @x.rangeBand()], @options.barSpacing)
    @y.range(layout.yRange)

    @xAxisSelection
      .attr("transform", layout.xTransform)
      .call(@xAxis)

    @yAxisSelection
      .attr("transform", layout.yTransform)
      .call(@yAxis)

    @groups.attr("transform", layout.groupsTransform)

    @bars
      .attr("x", layout.barX)
      .attr("y", layout.barY)
      .attr("width", layout.barWidth)
      .attr("height", layout.barHeight)

  draw: (data) ->
    super()
    @waitToBeInDom(() => @drawInternal(data))

  drawInternal: (data) ->
    normalizedBars = ((if Object.prototype.toString.call(d) == "[object Array]" then d else [d]) for d in data.bars)

    @y.domain([0, d3.max(d3.merge(normalizedBars, (bars) -> d3.max(bars)))])
    @x.domain(data.labels)
    @groupedX.domain(normalizedBars[0].map((a, i) -> i))

    if @options.ticks? && @options.ticks > 0
      @xAxis.tickValues(filterTicks(@options.ticks, @x, "ordinal"))

    if @options.layout == "vertical"
      @options.margin.left = @calc.calcLeftMargin(@yAxis, @options.margin.left)
    else
      # in order to calc the margin on the oridinal scale we need to set range round bands 
      # on the scale as a hack
      @x.rangeRoundBands([0, 10], .1)
      @options.margin.left = @calc.calcLeftMargin(@xAxis, @options.margin.left, "x")

    @xAxisSelection = @svg.chart.append("g")
      .attr("class", "x axis")

    @yAxisSelection = @svg.chart.append("g")
      .attr("class", "y axis")
    
    @groups = @svg.chart.selectAll(".barGroup")
      .data(data.labels)
      .enter()
      .append("g")
      .attr("class", (label, i) -> "barGroup barGroup-#{i} #{label}")

    @bars = @groups.selectAll(".bar")
      .data((label, i) -> normalizedBars[i])
      .enter()
      .append("rect")
      .attr("class", (barValue, i) -> "bar bar-#{i}")
    
    if @options.tooltips
      tooltipFormat = @options.tooltipFormat
      tip = (@tip ||= new Tooltip(document))
      @bars.on("mouseover", (d) ->
        tip.html(tooltipFormat(d))
        tip.show(this))

      @bars.on("mouseout", (d) -> tip.hide())
    @render()
    
module.exports = BarChart
