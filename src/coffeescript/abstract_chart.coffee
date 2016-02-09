class AbstractChart
  constructor: (selector, defaultOptions = {}, options = {}) ->
    @options = mergeOptions(defaultOptions, options)
    @svg = new Svg(selector, @options.aspectRatio, @options.margin)
