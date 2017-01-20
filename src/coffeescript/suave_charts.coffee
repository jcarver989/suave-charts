m = {}
m.LineChart = require('./line_chart')
m.BarChart = require('./bar_chart')
m.Histogram = require('./histogram')
m.DonutChart = require('./donut_chart')
m.GoalsChart = require('./goals_chart')

((mod) ->
  if mod.isBrowser then window.Suave = m else mod.exports = m
)(if typeof module == "undefined" then { isBrowser: true } else module)
