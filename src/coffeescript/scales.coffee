class Scales
  @fromString: (param) ->
    switch param
      when "linear" then d3.scale.linear()
      when "log" then d3.scale.log()
      when "time" then d3.time.scale()
      when "ordinal" then d3.scale.ordinal()

module.exports = Scales
