mergeOptions = (defaults, userSpecified) ->
  opts = {}
  for key, val of defaults
    opts[key] = defaults[key]

  for key, val of userSpecified
    opts[key] = userSpecified[key]

  opts

defaultLineOptions = {
  autoMargins: true
  aspectRatio: "16:9"
  dotSize: 6
  grid: true
  xScale: "ordinal" # linear, log, time
  yScale: "linear" # linear, log
  smoothLines: false # smooth chart lines 
  stack: false
  tooltips: true
  tickPadding: 10
  xLabelFormat: null # uses default
  yLabelFormat: null # uses default
  tooltipFormat: (y) -> d3.format(",.0f")(y)
  margin: {
    top: 50,
    bottom: 50,
    right: 80,
    left: 80
  }

  # Other arguments: 
  #xLabelInterval: "seconds", "days", "minutes", "months", "years"
}


defaultBarOptions = {
  aspectRatio: "16:9"
  grid: true
  tooltips: true
  layout: "vertical"
  xLabelFormat: null
  yLabelFormat: null
  tooltipFormat: (y) -> d3.format(",.0f")(y)
  barSpacing: 0.1
  margin: {
    top: 50,
    bottom: 50,
    right: 80,
    left: 80
  }
}

defaultHistogramOptions = {
  aspectRatio: "16:9"
  grid: true
  tooltips: true
  layout: "vertical"
  xLabelFormat: null
  yLabelFormat: null
  tooltipFormat: (y) -> d3.format(",.0f")(y)
  bins: 20
  ticks: 20
  domain: null
  margin: {
    top: 50,
    bottom: 50,
    right: 80,
    left: 80
  }
}

defaultDonutOptions = {
  aspectRatio: "16:9"
  holeSize: 0.5
  margin: {
    top: 0,
    bottom: 0,
    right: 0,
    left: 0
  }
}

module.exports = {
  mergeOptions: mergeOptions
  lineOptions: defaultLineOptions
  barOptions: defaultBarOptions
  histogramOptions: defaultHistogramOptions
  donutOptions: defaultDonutOptions
}
