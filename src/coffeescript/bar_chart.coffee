class BarChart
  constructor: (selector, options = {}) ->
    @options = defaultBarOptions
    @svg = new Svg(selector, @options.aspectRatio, @options.margin)
    @x = d3.scale.ordinal()
    @y = d3.scale.linear()

    @xAxis = d3.svg.axis()
      .scale(@x)
      .orient("bottom")

    @yAxis = d3.svg.axis()
      .scale(@y)
      .orient("left")

    d3.select(window).on('resize', @render)

  render: (isUpdate = true) =>
    @svg.resize()
    @x.rangeRoundBands([0, @svg.width], .1)
    @y.range([@svg.height, 0])
    @xAxisSelection
      .attr("transform", "translate(0, #{@svg.height})")
      .call(@xAxis)

    @yAxisSelection.call(@yAxis)

    @bars
      .attr("x", (d) => @x(d[0]))
      .attr("y", (d) => @y(d[1]))
      .attr("width", @x.rangeBand())
      .attr("height", (d) => @svg.height - @y(d[1]))

  # [[label, value], [label, value]]
  draw: (bars) ->
    @x.domain(bars.map((d) -> d[0]))
    @y.domain([0, d3.max(bars, (d) -> d[1])])

    @xAxisSelection = @svg.chart.append("g")
      .attr("class", "x axis")

    @yAxisSelection = @svg.chart.append("g")
      .attr("class", "y axis")
    
    @bars = @svg.chart.selectAll(".bar")
      .data(bars)
      
    @bars.enter()
      .append("rect")
      .attr("class", "bar")
      
    tip = (@tip ||= new Tooltip(document))
    @bars.on("mouseover", (d) ->
      tip.html(d[1])
      tip.show(this))

    @bars.on("mouseout", (d) -> tip.hide())
    @render(false)
    
