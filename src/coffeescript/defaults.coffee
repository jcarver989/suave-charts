colors = [
  "#1ABC9C",
  "#2ECC71",
  "#3498DB",
  "#9B59B6",
  "#34495E"
]


class ColorManager
  constructor: () ->
    @colors = colors
    @assignedColors = {}
    @current = 0

  getOrSet: (key) ->
    @assignedColors[key] ||= @nextColor()
    @assignedColors[key]

  set: (key, color) ->
    @assignedColors[key] = color

  nextColor: () ->
    index = @current % @colors.length
    @current += 1
    @colors[index]

defaultOptions = {
  xScale: d3.scale.linear()
  yScale: d3.scale.linear()
}





