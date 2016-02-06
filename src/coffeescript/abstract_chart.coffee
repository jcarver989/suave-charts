class AbstractChart
  constructor: (selector, options = {}) ->
    @options = @mergeOptions(defaultOptions, options)
    @svg = new Svg(selector, @options.margin)
    @scales = Scales.fromString(@options.xScale, @options.yScale)
    @axes = new Axes(@svg.chart, @scales, @options)
    
    [w, h] = @options.aspectRatio.split(":")
    @aspectRatio = [parseInt(w), parseInt(h)]
    @updateDimensions()

  mergeOptions: (defaults, userSpecified) ->
    opts = {}
    for key, val of defaults
      opts[key] = defaults[key]

    for key, val of userSpecified
      opts[key] = userSpecified[key]

    opts
    
  updateDimensions: () =>
    [w, h] = @svg.getSize()
    newHeight = w / @aspectRatio[0] * @aspectRatio[1]
    margin = @options.margin
    @width = w - margin.left - margin.right
    @height = newHeight - margin.bottom - margin.top
    @scales.setRanges(@width, @height)
    @svg.setSize(w, newHeight)
