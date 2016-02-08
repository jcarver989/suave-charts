class AbstractChart
  constructor: (selector, options = {}) ->
    @options = mergeOptions(defaultOptions, options)
    @svg = new Svg(selector, @options.aspectRatio, @options.margin)
