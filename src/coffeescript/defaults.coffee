mergeOptions = (defaults, userSpecified) ->
  opts = {}
  for key, val of defaults
    opts[key] = defaults[key]

  for key, val of userSpecified
    opts[key] = userSpecified[key]

  opts

defaultOptions = {
  xScale: "linear" # linear, log, time
  yScale: "linear" # linear, log
  smoothLines: false # smooth chart lines 
  tooltips: true
  aspectRatio: "16:9"
  tickPadding: 10
  dotSize: 6
  grid: true
  margin: {
    top: 50,
    bottom: 50,
    right: 80,
    left: 80
  }

  # Other arguments: 
  #xTickInterval: "seconds", "days", "minutes", "months", "years"
  #xTickFormat: "%Y-%m-%d"
}


defaultBarOptions = {
  aspectRatio: "16:9"

  margin: {
    top: 50,
    bottom: 50,
    right: 80,
    left: 80
  }
}

