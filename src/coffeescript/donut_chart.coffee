class DonutChart extends AbstractChart
  constructor: (selector, options = {}) ->
      super(selector, defaultDonutOptions, options)
      @options.margin = { top: 0, bottom: 0, left: 0, right: 0 }
      @arc = d3.svg.arc()
      @pie = d3.layout.pie()
      .sort(null)
      .value((d) -> d[1])

      window.addEventListener("resize", @render)

  render: () =>
    @svg.resize()
    radius = Math.min(@svg.width, @svg.height) / 2
    @svg.chart.attr("transform", "translate(#{@svg.width / 2}, #{@svg.height / 2})")

    @arc
    .innerRadius(radius)
    .outerRadius(radius - radius * @options.holeSize)

    @arcs.attr("d", @arc)
    @labels.attr("transform", (d) => "translate(#{@arc.centroid(d)})")
    
  draw: (data) =>
    s = (sum, d) -> sum + d[1]
    console.log(data.reduce(s, 0))
    arcSelection = @svg.chart.selectAll(".arc").data(@pie(data))
    @enter = arcSelection.enter()
      .append("g")
      .attr("class", (d, i) -> "arc arc-#{i} arc-#{d.data[0]}}")

    @arcs = @enter.append("path")
    @labels = @enter.append("text")
      .attr("dy", ".35em")
      .text((d) -> d.data[0])


    @render()

#g.append("text")
#.attr("transform", (d) => "translate(#{arc.centroid(d)})")
#.attr("dy", ".35em")
#.text((d) -> d[1])
