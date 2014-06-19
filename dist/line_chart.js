// Generated by CoffeeScript 1.7.1
var LineChart,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

LineChart = (function(_super) {
  __extends(LineChart, _super);

  function LineChart(selector, options) {
    this.options = options != null ? options : {};
    LineChart.__super__.constructor.call(this, selector, options);
    this.line = d3.svg.line().x((function(_this) {
      return function(d) {
        return _this.x(extractX(d));
      };
    })(this)).y((function(_this) {
      return function(d) {
        return _this.y(extractY(d));
      };
    })(this));
    this.area = d3.svg.area().x((function(_this) {
      return function(d) {
        return _this.x(extractX(d));
      };
    })(this)).y((function(_this) {
      return function(d) {
        return _this.y(extractY(d));
      };
    })(this)).y0(this.height);
  }

  LineChart.prototype.drawCircles = function(lines, data) {
    var circles;
    circles = lines.selectAll("circle").data(function(line) {
      var d, _i, _len, _ref;
      data = [];
      _ref = line.data;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        d = _ref[_i];
        d.label = line.label;
        data.push(d);
      }
      return data;
    });
    circles.transition().delay(200).attr("cx", (function(_this) {
      return function(d) {
        return _this.x(extractX(d));
      };
    })(this)).attr("cy", (function(_this) {
      return function(d) {
        return _this.y(extractY(d));
      };
    })(this));
    circles.enter().append("circle").attr("class", function(d) {
      return "dot " + d.label;
    }).attr("r", 5).attr("cx", (function(_this) {
      return function(d) {
        return _this.x(extractX(d));
      };
    })(this)).attr("cy", (function(_this) {
      return function(d) {
        return _this.y(extractY(d));
      };
    })(this));
    return circles.exit().remove();
  };

  LineChart.prototype.drawLines = function(enter, update) {
    enter.append("path").attr("class", function(d) {
      return "line " + d.label;
    }).attr("d", (function(_this) {
      return function(d) {
        return _this.line(d.data);
      };
    })(this));
    return update.select(".line").transition().delay(200).attr("d", (function(_this) {
      return function(d) {
        return _this.line(d.data);
      };
    })(this));
  };

  LineChart.prototype.drawAreas = function(enter, update) {
    enter.append("path").attr("class", function(d) {
      return "area " + d.label;
    }).attr("d", (function(_this) {
      return function(d) {
        return _this.area(d.data);
      };
    })(this));
    return update.select(".area").transition().delay(200).attr("d", (function(_this) {
      return function(d) {
        return _this.area(d.data);
      };
    })(this));
  };

  LineChart.prototype.draw = function(lines) {
    var allPoints, flattened, line, newLines;
    allPoints = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = lines.length; _i < _len; _i++) {
        line = lines[_i];
        _results.push(line.data);
      }
      return _results;
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
      return this.drawCircles(lines, allPoints);
    }
  };

  return LineChart;

})(AbstractChart);
