# D3 Charts

Easy, reusable charts built on d3.js. All of the power, none of the complexity.

## Getting Started

```html
    <html>
      <head>
        <script src="js/d3.js"></script>
        <script src="js/defaults.js"></script>
        <script src="js/svg.js"></script>
        <script src="js/abstract_chart.js"></script>
        <script src="js/line_chart.js"></script>

        <style>
            .axis path,
            .axis line {
              fill: none;
              stroke: #ccc;
              shape-rendering: crispEdges;
            }

            .dot {
              stroke: #fff;
              stroke-width: 3px;
            }

            .line {
              fill: none;
              stroke-width: 3px;
            }
        </style>

      </head>
        <body>
          <div id="chart"></div>

          <script>
              
          var data1 = [
            ["Jan 1, 2014", 10],
            ["Jan 2, 2014", 20],
            ["Jan 3, 2014", 30],
            ["Jan 4, 2014", 10],
            ["Jan 5, 2014", 5],
            ["Jan 6, 2014", 30],
            ["Jan 7, 2014", 35],
            ["Jan 8, 2014", 40]
          ].map(function (dataPoint) { return [new Date(dataPoint[0]), dataPoint[1]] })


           var data2 = [
            ["Jan 1, 2014", 100],
            ["Jan 2, 2014", 200],
            ["Jan 3, 2014", 300],
            ["Jan 4, 2014", 100],
            ["Jan 5, 2014", 50],
            ["Jan 6, 2014", 300],
            ["Jan 7, 2014", 305],
            ["Jan 8, 2014", 400]
          ].map(function (dataPoint) { return [new Date(dataPoint[0]), dataPoint[1]] })


          var chart = new LineChart("#chart", {
            xScale: d3.time.scale(),
            area: false,
            dots: true
          })

          chart.xAxis
          .ticks(d3.time.days)
          .tickFormat(d3.time.format("%Y-%m-%d"))

          chart.draw([ 
            { label: "line1", data: data1, color: "#00aadd", area_color: "rgba(0, 170, 221, 0.3)" }, 
            { label: "line2", data: data2  }
          ])
          </script>
        </body>
    </html>
```
