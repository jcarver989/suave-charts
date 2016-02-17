mergeOptions = (defaults, userSpecified) ->
  opts = {}
  for key, val of defaults
    opts[key] = defaults[key]

  for key, val of userSpecified
    opts[key] = userSpecified[key]

  opts

defaultLineOptions = {
  xScale: "linear" # linear, log, time
  yScale: "linear" # linear, log
  smoothLines: false # smooth chart lines 
  tooltips: true
  aspectRatio: "16:9"
  tickPadding: 10
  dotSize: 6
  grid: true
  xLabelFormat: null # uses default
  yLabelFormat: null # uses default
  tooltipFormat: (y) -> d3.format(",.0f")(y)
  autoMargins: true
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
  xLabelFormat: null,
  yLabelFormat: null,
  barSpacing: 0
  tooltipFormat: (y) -> d3.format(",.0f")(y)
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
  donutOptions: defaultDonutOptions
}
