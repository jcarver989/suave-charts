AbstractChart = require('./abstract_chart')
MarginCalculator = require('./margin_calculator')
Tooltip = require('./tooltip')
defaultBarOptions = require('./defaults').barOptions

class BarChart extends AbstractChart
  constructor: (selector, options = {}) ->
    super(selector, defaultBarOptions, options)
    @calc = new MarginCalculator(@svg)
    @x = d3.scale.ordinal()
    @groupedX = d3.scale.ordinal()
    @y = d3.scale.linear()

    @xAxis = d3.svg.axis()
      .scale(@x)
      .orient("bottom")
      .tickFormat(@options.xLabelFormat)

    @yAxis = d3.svg.axis()
      .scale(@y)
      .orient("left")
      .tickFormat(@options.yLabelFormat)

    window.addEventListener("resize", @render)

  render: () =>
    @svg.resize()
    @x.rangeRoundBands([0, @svg.width], .1)
    @groupedX.rangeRoundBands([0, @x.rangeBand()], .1)
    @y.range([@svg.height, 0])
    @xAxisSelection
      .attr("transform", "translate(0, #{@svg.height})")
      .call(@xAxis)

    @yAxisSelection.call(@yAxis)
    @groups.attr("transform", (label) => "translate(#{@x(label)}, 0)")

    @bars
      .attr("x", (barValue, i) => @groupedX(i))
      .attr("y", (barValue) => @y(barValue))
      .attr("width", @groupedX.rangeBand())
      .attr("height", (barValue) => @svg.height - @y(barValue))

  draw: (data) ->
    normalizedBars = ((if Object.prototype.toString.call(d) == "[object Array]" then d else [d]) for d in data.bars)

    @y.domain([0, d3.max(d3.merge(normalizedBars, (bars) -> d3.max(bars)))])
    @x.domain(data.labels)
    @groupedX.domain(normalizedBars[0].map((a, i) -> i))
    @options.margin.left = @calc.calcLeftMargin(@yAxis, @options.margin.left)

    @xAxisSelection = @svg.chart.append("g")
      .attr("class", "x axis")

    @yAxisSelection = @svg.chart.append("g")
      .attr("class", "y axis")
    
    @groups = @svg.chart.selectAll(".bar-group")
      .data(data.labels)
      .enter()
      .append("g")
      .attr("class", (label) -> "bar-group #{label}")

    @bars = @groups.selectAll(".bar")
      .data((label, i) -> normalizedBars[i])
      .enter()
      .append("rect")
      .attr("class", (barValue, i) -> "bar #{i}")
      
    tooltipFormat = @options.tooltipFormat
    tip = (@tip ||= new Tooltip(document))
    @bars.on("mouseover", (d) ->
      tip.html(tooltipFormat(d))
      tip.show(this))

    @bars.on("mouseout", (d) -> tip.hide())
    @render()
    
module.exports = BarChart
