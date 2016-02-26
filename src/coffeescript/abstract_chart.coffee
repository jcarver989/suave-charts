defaults = require('./defaults')
Svg = require('./svg')

class AbstractChart
  constructor: (selector, defaultOptions = {}, options = {}) ->
    @options = defaults.mergeOptions(defaultOptions, options)
    @svg = new Svg(selector, @options.aspectRatio, @options.margin)
    @listenerBound = false
    @axisLabelPadding = 10 

  draw: () ->
    unless @listenerBound
      window.addEventListener("resize", @render)
      @listenerBound = true

  remove: () ->
    window.removeEventListener("resize", @render)
    element = @svg.domElement
    while element.firstChild
      element.removeChild(element.firstChild)

module.exports = AbstractChart
