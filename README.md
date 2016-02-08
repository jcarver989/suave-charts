# Suave Charts
Easy, reusable charts built on d3.js. All of the power, none of the complexity.

## Getting Started, Easy as 1, 2, 3

#### 1. Include d3.js. Then include suave-charts.min.js and suave-charts.css from dist/ in your HTML

```html
    <!doctype html>
    <html>
      <head>
        <link rel="stylesheet" type="text/css" href="dist/suave-charts.css">
        <script src="examples/vendor/d3.min.js"></script>
        <script src="dist/suave-charts.min.js"></script>
      </head>
    </html>
```

#### 2. Draw a chart:

```html
      <body>
        <div id="chart"></div>
        <script>
          var data = [[1, 2], [2, 10], [3, 20]] // array of [x,y] points
          var chart = new LineChart("#chart")
          chart.draw([{ label: "line1", data: data1 }])
        </script>
      </body>
```


#### 3. Customize the chart with CSS

```css
/* We labeled the line in the chart above "line1" so the SVG path for the line gets a CSS class of the same name */
.line1.line {
  stroke: #00aadd; /* blue */
}


.line1.dot {
  fill: #000; /* black */
}
```


##  Line Chart Options
Available options to pass to `new LineChart(selector, options)`

- xScale: String, the type of xScale to use. ["linear", "time"], default "linear"
- yScale: String, the type of yScale to use. ["linear", "log"], default "linear"
- smoothLines: Boolean. Smooth chart lines via cubic interpolation that preserves monotonicity. default false
- tooltips: Boolean. Enable tooltips on hover over a dot
- aspectRatio: String. The aspect ratio to preserve when the window is resized. Default: "16:9"
- tickPadding: Int. The spacing in pixels between "ticks" on the xAxis. Default 10 
- dotSize: Int. The radius of data points on the svg chart. Default 6
- grid: Boolean. Enables/disables showing a grid behind the chart. Default true.
- margin: Js Object with Int properties top, left, right, bottom. Controls how much room for labels the chart has. Default  { top: 50, bottom: 50, right: 80, left: 80 }
- xTickInterval: String. If xScale is "time", this can be set to control the "step-size" ex: "seconds", "days", "minutes", "months", "years"
- xTickFormat: String. If the xScale is "time" this controls the format of the date, ex: "%Y-%m-%d"

## See examles/ For More
