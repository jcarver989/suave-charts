// Generated by CoffeeScript 1.10.0
var LineChart,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

LineChart = (function(superClass) {
  extend(LineChart, superClass);

  function LineChart(selector, options) {
    if (options == null) {
      options = {};
    }
    LineChart.__super__.constructor.call(this, selector, options);
    this.line = d3.svg.line().interpolate("cardinal").x((function(_this) {
      return function(d) {
        return _this.x(extractX(d));
      };
    })(this)).y((function(_this) {
      return function(d) {
        return _this.y(extractY(d));
      };
    })(this));
    this.area = d3.svg.area().interpolate("cardinal").x((function(_this) {
      return function(d) {
        return _this.x(extractX(d));
      };
    })(this)).y((function(_this) {
      return function(d) {
        return _this.y(extractY(d));
      };
    })(this)).y0(this.height);
  }

  LineChart.prototype.drawCircles = function(lines, data, tooltips) {
    var circles, newCircles, tip;
    circles = lines.selectAll("circle").data(function(line) {
      var d, j, len, ref;
      data = [];
      if (line.dots !== false) {
        ref = line.data;
        for (j = 0, len = ref.length; j < len; j++) {
          d = ref[j];
          d.label = line.label;
          data.push(d);
        }
      }
      return data;
    });
    newCircles = circles.enter().append("circle").attr("class", function(d) {
      return "dot " + d.label;
    }).attr("r", 6).attr("cx", (function(_this) {
      return function(d) {
        return _this.x(extractX(d));
      };
    })(this)).attr("cy", (function(_this) {
      return function(d) {
        return _this.y(extractY(d));
      };
    })(this));
    circles.attr("transform", "translate(0, " + this.height + ")").attr("opacity", 0).transition().duration(1000).delay((function(_this) {
      return function(d, i) {
        var delay;
        delay = d.label === "line1" ? i * 50 : i * 20;
        return delay + 500;
      };
    })(this)).attr("opacity", 1).attr("transform", "translate(0, 0)");
    if (tooltips) {
      tip = (this.tip || (this.tip = new Tooltip(document)));
      circles.on("mouseover", function(d) {
        tip.html(d[1]);
        return tip.show(this);
      }).on("mouseout", function(d) {
        return tip.hide();
      });
    }
    return circles.exit().remove();
  };

  LineChart.prototype.drawLines = function(enter, update) {
    var nPaths, paths;
    paths = enter.append("path").attr("class", function(d) {
      return "line " + d.label;
    }).attr("d", (function(_this) {
      return function(d) {
        return _this.line(d.data.map(function(datum) {
          return [datum[0], 0];
        }));
      };
    })(this));
    nPaths = paths.size();
    return paths.transition().duration(1300).delay((function(_this) {
      return function(d, i) {
        return (nPaths - i) * 200 + 500;
      };
    })(this)).attr("d", (function(_this) {
      return function(d) {
        return _this.line(d.data);
      };
    })(this));
  };

  LineChart.prototype.drawAreas = function(enter, update) {
    var path;
    path = enter.filter(function(d) {
      return d.area !== false;
    }).append("path").attr("class", function(d) {
      return "area " + d.label;
    }).attr("d", (function(_this) {
      return function(d) {
        return _this.area(d.data);
      };
    })(this));
    return path.style("fill-opacity", 0).transition().duration(1000).delay(1000 + 500).style("fill-opacity", 1);
  };

  LineChart.prototype.draw = function(lines) {
    var allPoints, flattened, line, newLines;
    allPoints = (function() {
      var j, len, results;
      results = [];
      for (j = 0, len = lines.length; j < len; j++) {
        line = lines[j];
        results.push(line.data);
      }
      return results;
    })();
    flattened = d3.merge(allPoints);
    this.x.domain(d3.extent(flattened, extractX));
    this.y.domain([0, d3.max(flattened, extractY)]);
    this.drawAxes();
    lines = this.svg.selectAll(".lineGroup").data(lines, function(d) {
      return d.label;
    });
    newLines = lines.enter().append("g").attr("class", "lineGroup");
    lines.exit().remove();
    this.drawLines(newLines, lines);
    if (this.options.area) {
      this.drawAreas(newLines, lines);
    }
    if (this.options.dots) {
      return this.drawCircles(lines, allPoints, this.options.tooltips);
    }
  };

  return LineChart;

})(AbstractChart);
