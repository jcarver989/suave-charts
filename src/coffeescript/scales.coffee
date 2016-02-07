class Scales
  @fromString: (x, y) -> new Scales(Scales.selectScale(x), Scales.selectScale(y))

  @selectScale: (param) ->
    switch param
      when "linear" then d3.scale.linear()
      when "log" then d3.scale.log()
      when "time" then d3.time.scale()
      when "ordinal" then d3.scale.ordinal()

  constructor: (@x, @y) ->

  scaleX: (pair) => @x(pair[0])
  scaleY: (pair) => @y(pair[1])

  setDomains: (points) =>
    @x.domain(d3.extent(points, (d) -> d[0])).nice()
    @y.domain([0, d3.max(points, (d) -> d[1])]).nice()

  setRanges: (width, height) =>
    @x.range [0, width]
    @y.range [height, 0]
