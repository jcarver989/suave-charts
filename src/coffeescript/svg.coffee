class Svg
  constructor: (selector, margin) ->
    @domElement = document.querySelector(selector) 
    @container = d3
      .select(@domElement)
      .append("svg")
      .attr('preserveAspectRatio','xMinYMin')

    @chart = @container.
      append("g")
      .attr("transform", "translate(#{margin.left},#{margin.top})")

   getSize: () ->
    [@domElement.offsetWidth, @domElement.offsetHeight]
    
   setSize: (width, height) ->
    @container
      .attr("width", width)
      .attr("height", height)
