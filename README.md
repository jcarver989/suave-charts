# Suave Charts
Easy, reusable charts built on d3.js. All of the power, none of the complexity.

## Getting Started, Easy as 1, 2, 3

#### 1. Include d3, suave-charts.min.js and suave-charts.css in your HTML

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
