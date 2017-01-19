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

    y = @y
    @yAxis.tickSize(-@svg.width, 0) if @options.grid
    layout = {
      xTransform: "translate(0, #{@svg.height})",
      yTransform: "",
      groupsTransform: (label) => "translate(#{@x(label)}, 0)",
      xRange: [0, @svg.width],
      yRange: [@svg.height, 0],
      barX: (barValue, i) => @groupedX(i),
      barY: (barValue) => @y(barValue.value),
      barWidth: () => @groupedX.rangeBand(),
      barHeight: (barValue) => @svg.height - @y(barValue.value)
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

    sum = () =>
      s = 0
      @bars.each((d) -> s += d.value)
      s

    @totalBar
      .datum({value: sum() })
      .attr("x", layout.barX)
      .attr("y", layout.barY)
      .attr("width", layout.barWidth)
      .attr("height", layout.barHeight)

    @totalBarBackground
      .datum({ value: 100 })
      .attr("x", layout.barX)
      .attr("y", layout.barY)
      .attr("width", layout.barWidth)
      .attr("height", layout.barHeight)

    
    limit = (value, min, max) ->
      if (value >= max)
        max
      else if value <= min
        min
      else 
        value

    totalBar = @totalBar
    drag = d3.behavior.drag()
      .on("drag", (e) ->
        invertedValue = y.invert(d3.event.y)
        delta = invertedValue - e.value
        totalBarValue = sum()
        value = limit(invertedValue, 0, (100 - totalBarValue) + e.value)

        totalBar
          .attr("height", layout.barHeight({ value: totalBarValue }))
          .attr("y", layout.barY({ value: totalBarValue }))

        handle = d3.select(this)
        handle.attr("cy",  y(value))
        rect = d3
          .select(this.parentNode)
          .select("rect")
          .attr("height", layout.barHeight({ value: value }))
          .attr("y", layout.barY({ value: value }))
        e.value = value
        totalBar.each((d) -> d.value = sum())
      )

    @dots
       .attr("cx", (d,i) -> layout.barX(d,i) + 0.5 * layout.barWidth())
       .attr("cy", (d) -> layout.barY(d) + 2.5)
       .attr("class", "drag-handle")
       .call(drag)

  draw: (data) ->
    super()
    @waitToBeInDom(() => @drawInternal(data))

  drawInternal: (data) ->
    data.labels.push("Total")
    normalizedBars = ((if Object.prototype.toString.call(d) == "[object Array]" then d else [d]) for d in data.bars)
    normalizedBars.push([100])

    @y.domain([0, 100])
    @x.domain(data.labels)
    @groupedX.domain(normalizedBars[0].map((a, i) -> i))

    if @options.ticks? && @options.ticks > 0
      @xAxis.tickValues(filterTicks(@options.ticks, @x, "ordinal"))

    if @options.layout == "vertical"
      @options.margin.left = @calc.calcLeftMargin(@yAxis, @options.margin.left)

    @xAxisSelection = @svg.chart.append("g")
      .attr("class", "x axis")

    @yAxisSelection = @svg.chart.append("g")
      .attr("class", "y axis")
    
    @groups = @svg.chart.selectAll(".barGroup")
      .data(data.labels)
      .enter()
      .append("g")
      .attr("class", (label, i) -> "barGroup barGroup-#{i} #{label}")

    @barGroups = @groups.selectAll(".bar")
      .data((label, i) -> normalizedBars[i].map((v) -> { value: v }))
      .enter()
      .append("g")
      .attr("class", (barValue, i) -> "bar bar-#{i}")

      
    @bars = @barGroups
      .filter((data, zero, i) -> i + 1 < normalizedBars.length)
      .append("rect")

    # total bar
    @totalBarGroup = @barGroups
      .filter((data, zero, i) -> i + 1 == normalizedBars.length)
      .append("g")

    @totalBarBackground = @totalBarGroup
      .append("rect")
      .attr("id", "totalBackground")

    @totalBar = @totalBarGroup
      .append("rect")
      .attr("id", "total")

    @dots = @barGroups
      .filter((data, zero, i) -> i + 1 < normalizedBars.length)
      .append("circle")
      .attr("r", 5)

    if @options.tooltips
      tooltipFormat = @options.tooltipFormat
      tip = (@tip ||= new Tooltip(document))
      @bars.on("mouseover", (d) ->
        tip.html(tooltipFormat(d.value))
        tip.show(this))

      @bars.on("mouseout", (d) -> tip.hide())

      @totalBar.on("mouseover", (d) ->
        tip.html(tooltipFormat(d.value))
        tip.show(this))

      @totalBar.on("mouseout", (d) -> tip.hide())

    @render()
    
module.exports = BarChart
