AbstractChart = require('./abstract_chart')
MarginCalculator = require('./margin_calculator')
Tooltip = require('./tooltip')
defaultHistogramOptions = require('./defaults').histogramOptions

class Histogram extends AbstractChart
  constructor: (selector, options = {}) ->
    super(selector, defaultHistogramOptions, options)
    @calc = new MarginCalculator(@svg)
    @x = d3.scale.linear()
    @y = d3.scale.linear()

    @xAxis = d3.svg.axis()
      .scale(@x)
      .outerTickSize(0)
      .tickFormat(@options.xLabelFormat)
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
    first = @histogram[0]
    layout = if @options.layout == "vertical"
      @yAxis.tickSize(-@svg.width, 0) if @options.grid
      {
        xRange: [0, @svg.width]
        yRange: [@svg.height, 0]
        xTransform: "translate(0, #{@svg.height})"
        yTransform: ""
        barsTransform: (d) => "translate(#{@x(d.x)}, #{@y(d.y)})"
        barWidth: (d) => @x(first.x + first.dx) - @x(first.x) - 1
        barHeight: (d) => @svg.height - @y(d.y)
      }
    else
      @yAxis.tickSize(-@svg.height, 0) if @options.grid
      {
        xRange: [0, @svg.height]
        yRange: [0, @svg.width]
        xTransform: ""
        yTransform: "translate(0, #{@svg.height})"
        barsTransform: (d) => "translate(0, #{@x(d.x)})"
        barWidth: (d) => @y(d.y)
        barHeight: (d) => @x(first.x + first.dx) - @x(first.x) - 1
      }

    @x.range(layout.xRange)
    @y.range(layout.yRange)

    @xAxisSelection
      .attr("transform", layout.xTransform)
      .call(@xAxis)

    @yAxisSelection
      .attr("transform", layout.yTransform)
      .call(@yAxis)
    
    @bars.attr("transform", layout.barsTransform)

    @rects
      .attr("width", layout.barWidth)
      .attr("height", layout.barHeight)

  draw: (data) ->
    super()
    hist = d3.layout.histogram()
    if @options.domain
      @x.domain(@options.domain)
      @histogram = hist.bins(@x.ticks(@options.bins))(data.values)
      @xAxis.ticks(@options.bins)
    else
      @x.domain(d3.extent(data.values)).nice()
      ticks = @x.ticks(@options.bins)
      @histogram = hist.bins(ticks)(data.values)
      @xAxis.tickValues(ticks)

    @y.domain([0, d3.max(@histogram, (d) -> d.y)]).nice()
    @options.margin.left = @calc.calcLeftMargin(@yAxis, @options.margin.left)

    @xAxisSelection = @svg.chart.append("g")
      .attr("class", "x axis")

    @yAxisSelection = @svg.chart.append("g")
      .attr("class", "y axis")

    @bars = @svg.chart.selectAll(".bar")
      .data(@histogram)
      .enter()
      .append("g")
      .attr("class", "bar")

    @rects = @bars.append("rect")
      .attr("x", 1)
    
    if @options.tooltips
      tooltipFormat = @options.tooltipFormat
      tip = (@tip ||= new Tooltip(document))
      @bars.on("mouseover", (d) ->
        tip.html(tooltipFormat(d.y))
        tip.show(this))
    
    @render()
    
module.exports = Histogram
