class AbstractChart
  constructor: (selector, options = {}) ->
    @options = @mergeOptions(defaultOptions, options)
    @svg = new Svg(selector, @options.aspectRatio, @options.margin)
    @scales = Scales.fromString(@options.xScale, @options.yScale)
    @axes = new Axes(@svg.chart, @scales, @options)
    @updateDimensions()

  mergeOptions: (defaults, userSpecified) ->
    opts = {}
    for key, val of defaults
      opts[key] = defaults[key]

    for key, val of userSpecified
      opts[key] = userSpecified[key]

    opts
    
  updateDimensions: () =>
    @svg.resize()
    @scales.setRanges(@svg.width, @svg.height)
