filterTicks = (num, scale) ->
    domain = scale.domain()
    step = domain.length / (num - 2.0)
    domain.filter((label, i) ->
      if (i == 0 || label == domain[domain.length-1])
        true
      else
        i % step == 0
    )

module.exports = filterTicks
