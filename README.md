# Suave Charts
Easy, reusable charts built on d3.js. All of the power, none of the complexity.

## What's Available?

1. Mulit-series Line Charts (time series or linear x-lables)
2. Bar Charts

Suave Charts are responsive by default. As a result you don't specify chart sizes in pixels, rather you supply an aspectRatio (default of 16:9)
Then when your viewport changes Suave Charts will automatically resize your charts using the aspectRatio specified. If you want to fix a chart's size
you can easily do so via CSS rules on the chart container. 

## Roadmap, What's Coming?

1. Support for logarithmic scales in line/bar charts.
2. Multi-axis line charts
3. Grouped bar charts
4. Histograms
5. Smart redrawing for Ajax applications that need to add/remove data as a user selects it.
6. Pre-packaged CSS themes for charts to make it easy for non-designers to have great looking visualizations. 
7. Optional animations & transitions for when data changes to help bring attention to what data has changed.

## Getting Started

1. Clone this repo
2. Open some examples from the examples/ directory in your browser. They include both a working visual example + the code to create it.

##  Line Chart Options
Available options to pass to `new LineChart(selector, options)`

- xScale: String, the type of xScale to use. ["linear", "time"], default "linear"
- yScale: String, the type of yScale to use. ["linear", "log"], default "linear"
- tooltips: Boolean. Enable tooltips on hover over a dot
- aspectRatio: String. The aspect ratio to preserve when the window is resized. Default: "16:9"
- tickPadding: Int. The spacing in pixels between "ticks" on the xAxis. Default 10 
- dotSize: Int. The radius of data points on the svg chart. Default 6
- grid: Boolean. Enables/disables showing a grid behind the chart. Default true.
- margin: Js Object with Int properties top, left, right, bottom. Controls how much room for labels the chart has. Default  { top: 50, bottom: 50, right: 80, left: 80 }
- xTickInterval: String. If xScale is "time", this can be set to control the "step-size" ex: "seconds", "days", "minutes", "months", "years"
- xTickFormat: String. If the xScale is "time" this controls the format of the date, ex: "%Y-%m-%d"

Available options to pass to 'LineChart.draw([{ }])` i.e. per-line options:

- dots: Boolean. Toggles renering of data points on/off (required to be true for tooltips to work)
- area: Boolean. Toggles drawing a shaded region below the line.
- smooth: Boolean. Smooth chart lines via cubic interpolation that preserves monotonicity.
