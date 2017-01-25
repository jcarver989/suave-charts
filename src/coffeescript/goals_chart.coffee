AbstractChart = require('./abstract_chart')
MarginCalculator = require('./margin_calculator')
Tooltip = require('./tooltip')
defaultBarOptions = require('./defaults').barOptions
filterTicks = require('./filter_ticks')

class GoalsChart extends AbstractChart
  constructor: (selector, options = {}) ->
    super(selector, defaultBarOptions, options)
    @calc = new MarginCalculator(@svg)
    @x = d3.scale.ordinal()
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
      .ticks(5)

    @xAxis.orient("bottom")
    @yAxis.orient("left")
    @tipPadding = 20

  sum: () =>
    s = @y.domain()[1]
    @bars.each((d) -> s -= d.value)
    s

  render: () =>
    @svg.resize()
    @x.rangeRoundBands([0, @svg.width])
    @yAxis.tickSize(-@svg.width, 0) if @options.grid

    layout = {
      xTransform: "translate(0, #{@svg.height})",
      yTransform: "",
      groupsTransform: (label) => "translate(#{@x(label)}, 0)",
      xRange: [0, @svg.width],
      yRange: [@svg.height, 0],
      barX: (bar) => @x(bar.label),
      barY: (bar) => @y(bar.value),
      barWidth: () => @x.rangeBand(),
      barHeight: (bar) => @svg.height - @y(bar.value)
    }

    @x.rangeRoundBands(layout.xRange, @options.barSpacing)
    @y.range(layout.yRange)

    @xAxisSelection
      .attr("transform", layout.xTransform)
      .call(@xAxis)
      .selectAll(".tick text")
      .call(@wrap2, layout.barWidth())

    @yAxisSelection
      .attr("transform", layout.yTransform)
      .call(@yAxis)

    @bars
      .attr("x", layout.barX)
      .attr("y", layout.barY)
      .attr("width", layout.barWidth)
      .attr("height", layout.barHeight)

    @totalBar
      .attr("x", layout.barX)
      .attr("y", layout.barY)
      .attr("width", layout.barWidth)
      .attr("height", layout.barHeight)

    @totalBarBackground
      .attr("x", layout.barX)
      .attr("y", 0)
      .attr("width", layout.barWidth)
      .attr("height", @y.range()[0])

    @tooltips
      .attr("x", (d) => layout.barX(d) + 0.5 * layout.barWidth())
      .attr("y", (d) => Math.min(layout.barY(d) - @tipPadding, @svg.height - @tipPadding))
      .text((d) => @options.tooltipFormat(d.value))

    @totalBarTooltip
      .attr("x", (d) => layout.barX(d) + 0.5 * layout.barWidth())
      .attr("y", (d) => Math.min(layout.barY(d) - @tipPadding, @svg.height - @tipPadding))
      .text((d) => @options.tooltipFormat(d.value))


    totalBar = @totalBar
    totalBarTooltip = @totalBarTooltip
    x = @x
    y = @y
    sum = @sum
    tooltipFormat = @options.tooltipFormat
    tipPadding = @tipPadding
    onChangeCallback = @onChangeCallback
    drag = d3.behavior.drag()
    drag.on("drag", (e) ->
        # have an existing value. The new value's delta can't exceed the remaining space
        totalBarValue = sum()
        delta = Math.min(Math.round(y.invert(d3.event.y) - e.value), totalBarValue)
        newValue = Math.max(0, Math.min(e.value + delta, y.domain()[1]))
        e.value = newValue

        handle = d3.select(this)
        handle.attr("cy",  y(newValue))
        parent = d3.select(this.parentNode)
        parent
          .select("rect")
          .attr("height", layout.barHeight({ value: newValue }))
          .attr("y", layout.barY({ value: newValue }))

        parent
          .select("text")
          .attr("y", (d) -> layout.barY(d) - tipPadding)
          .text(tooltipFormat(newValue))

        newTotalBarValue = sum()
        totalBar.each((d) -> d.value = newTotalBarValue)
        totalBar
          .attr("height", layout.barHeight({ value: newTotalBarValue }))
          .attr("y", layout.barY({ value: newTotalBarValue }))

        totalBarTooltip
          .attr("y", layout.barY({ value: newTotalBarValue }) - tipPadding)
          .text(tooltipFormat(newTotalBarValue))
    )

    drag.on("dragend", (e) ->
      if onChangeCallback? then onChangeCallback({ label: e.label, value: e.value, remaining: sum() })
    )

    @dots
       .attr("cx", (d) => layout.barX(d) + 0.5 * layout.barWidth())
       .attr("cy", (d) => layout.barY(d) + 0.5 * @options.dotSize)
       .attr("class", "drag-handle")
       .call(drag)




  wrap2: (text, width) ->
    text.each(() ->
      text = d3.select(this)
      y = text.attr('y')
      dy = parseFloat(text.attr('dy'))
      dy = parseFloat(text.attr('dy'))
      words = text.text().split(/([0-9]+ year.*)/)
      lineHeight = 1.5
      text.text(null)
      words.forEach((w, i) ->
        text.append("tspan").attr("x", 0).attr('y', y).attr('dy', i * lineHeight + dy + 'em').text(w)
      )
    )

  wrap: (text, width) ->
    text.each(() ->
      text = d3.select(this)
      words = text.text().split(/\s+/).reverse()
      word = undefined
      line = []
      lineNumber = 0
      lineHeight = 1.1
      y = text.attr('y')
      dy = parseFloat(text.attr('dy'))
      tspan = text.text(null).append('tspan').attr('x', 0).attr('y', y).attr('dy', dy + 'em')
      while word = words.pop()
        line.push(word)
        tspan.text(line.join(' '))
        if (tspan.node().getComputedTextLength() > width)
          line.pop()
          tspan.text line.join(' ')
          line = [ word ]
          tspan = text.append('tspan').attr('x', 0).attr('y', y).attr('dy', ++lineNumber * lineHeight + dy + 'em').text(word)
    )

  draw: (data) ->
    super()
    @onChangeCallback = data.onChangeCallback
    @waitToBeInDom(() => @drawInternal(data))

  drawInternal: (data) ->
    startingTotal = data.bars.reduce(
      (a, b) -> a + b,
      0
    )

    barData = [{ value: startingTotal, label: data.domainLabel }]
    data.bars.forEach((v, i) -> barData.push({ value: v, label: data.labels[i] }))

    @y.domain(data.domain)
    @x.domain(barData.map((d) -> d.label))

    @options.margin.left = @calc.calcLeftMargin(@yAxis, @options.margin.left)

    @xAxisSelection = @svg.chart.append("g")
      .attr("class", "x axis")

    @yAxisSelection = @svg.chart.append("g")
      .attr("class", "y axis")

    @groups = @svg.chart.selectAll(".barGroup")
      .data(barData)
      .enter()
      .append("g")
      .attr("class", (bar, i) -> "barGroup barGroup-#{i} #{bar.label}")

    @barGroups = @groups
      .append("g")
      .attr("class", (bar, i) -> "bar bar-#{i}")

    @barGroupsWithoutTotal = @barGroups
      .filter((data, i) -> i !=0)

    @bars = @barGroupsWithoutTotal.append("rect")
    @dots = @barGroupsWithoutTotal
      .append("circle")
      .attr("r", @options.dotSize)

    @tooltips = @barGroupsWithoutTotal
      .append("text")
      .attr("text-anchor", "middle")

    # total bar
    @totalBarGroup = @barGroups
      .filter((data, i) -> i == 0)
      .datum({ value: @sum(), label: data.domainLabel})
      .append("g")
      .attr("class", "total")

    @totalBarBackground = @totalBarGroup
      .append("rect")
      .attr("class", "background")

    @totalBar = @totalBarGroup
      .append("rect")
      .attr("class", "sum")

    @totalBarTooltip = @totalBarGroup
      .append("text")
      .attr("text-anchor", "middle")

    @render()

module.exports = GoalsChart
