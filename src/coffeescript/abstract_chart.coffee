defaults = require('./defaults')
Svg = require('./svg')

class AbstractChart
  constructor: (selector, defaultOptions = {}, options = {}) ->
    @options = defaults.mergeOptions(defaultOptions, options)
    @svg = new Svg(selector, @options.aspectRatio, @options.margin)

module.exports = AbstractChart
