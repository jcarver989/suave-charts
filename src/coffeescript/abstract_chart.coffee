class AbstractChart
  constructor: (selector, options = {}) ->

    opts = {}
    for key, val of defaultOptions
      opts[key] = defaultOptions[key]

    for key, val of options
      opts[key] = options[key]

    # create canvas
    [@svg, @width, @height] = createSvg(d3, selector)

    # scales
    @x = opts.xScale.range [0, @width]
    @y = opts.yScale.range [@height, 0]

    # axes
    @xAxis = d3.svg.axis()
    .scale(@x)
    .orient("bottom")
    .tickPadding(20)

    @yAxis = d3.svg.axis()
      .scale(@y)
      .orient("left")
      .tickPadding(20)

    if opts.grid
      @xAxis.tickSize(-@height)
      @yAxis.tickSize(-@width)

    @xAxisSelection = @svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + @height + ")")

    @yAxisSelection = @svg.append("g")
      .attr("class", "y axis")

  drawAxes: () ->
    @xAxisSelection.call @xAxis
    @yAxisSelection.call @yAxis
