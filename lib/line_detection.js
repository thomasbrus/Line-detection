(function() {
  var Line, LineScore, Point, Vector, best, bestLines, connectTheDots, line, n, paper, points, v1, v2, _, _i, _len;

  _ = require('underscore');

  n = 6;

  paper = {
    width: 640,
    height: 480
  };

  Math.randInt = function(n) {
    return Math.floor(Math.random() * n);
  };

  Math.sqr = function(n) {
    return n * n;
  };

  Array.prototype.sum = function() {
    return this.reduce((function(a, b) {
      return a + b;
    }), 0);
  };

  Point = (function() {

    function Point(x, y) {
      this.x = x;
      this.y = y;
    }

    Point.prototype.distanceTo = function(other) {
      return Math.sqrt(Math.sqr(other.x - this.x) + Math.sqr(other.y - this.y));
    };

    return Point;

  })();

  Line = (function() {

    function Line(p1, p2) {
      this.p1 = p1;
      this.p2 = p2;
    }

    Line.prototype.length = function() {
      return Math.sqrt(Math.sqr(this.p2.x - this.p1.x) + Math.sqr(this.p2.y - this.p1.y));
    };

    Line.prototype.toVector = function() {
      return new Vector(this.p2.x - this.p1.x, this.p2.y - this.p1.y);
    };

    return Line;

  })();

  Vector = (function() {

    function Vector(a, b) {
      this.a = a;
      this.b = b;
    }

    Vector.prototype.length = function() {
      return Math.sqrt(Math.sqr(this.a) + Math.sqr(this.b));
    };

    Vector.dotProduct = function(v1, v2) {
      return v1.a * v2.a + v1.b * v2.b;
    };

    Vector.prototype.scalarProjection = function(other) {
      return Vector.dotProduct(this, other) / this.length();
    };

    Vector.prototype.vectorProjection = function(other) {
      var scalar;
      scalar = Vector.dotProduct(this, other) / Math.sqr(this.length());
      return new Vector(this.a * scalar, this.b * scalar);
    };

    return Vector;

  })();

  LineScore = (function() {

    function LineScore(line, points) {
      this.line = line;
      this.points = points;
      this.points = LineScore.sort(this.line, this.points);
    }

    LineScore.sort = function(line, points) {
      var _this = this;
      return _.sortBy(points, function(point) {
        return line.toVector().scalarProjection((new Line(line.p1, point)).toVector());
      });
    };

    LineScore.prototype.calculate = function() {
      var i, scalar, vector, _ref, _results;
      _results = [];
      for (i = 0, _ref = this.points.length - 1; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
        vector = (new Line(this.points[i], this.points[i + 1])).toVector();
        scalar = this.line.toVector().scalarProjection(vector);
        _results.push(scalar / vector.length());
      }
      return _results;
    };

    LineScore.prototype.remove = function(point) {
      var p;
      return this.points = (function() {
        var _i, _len, _ref, _results;
        _ref = this.points;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          p = _ref[_i];
          if (!_.isEqual(p, point)) _results.push(p);
        }
        return _results;
      }).call(this);
    };

    return LineScore;

  })();

  points = (function() {
    var _i, _results;
    _results = [];
    for (_i = 1; 1 <= n ? _i <= n : _i >= n; 1 <= n ? _i++ : _i--) {
      _results.push(new Point(Math.randInt(paper.width), Math.randInt(paper.height)));
    }
    return _results;
  })();

  points = [new Point(5, 0), new Point(5, 5), new Point(5, 10)];

  v1 = new Vector(0, 5);

  v2 = new Vector(4, 4);

  console.log(v1.length(), v2.length(), v1.scalarProjection(v2));

  connectTheDots = function(points) {
    var i, j, lines, _ref, _ref2;
    lines = [];
    for (i = 0, _ref = points.length - 1; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
      for (j = 1, _ref2 = points.length - i; 1 <= _ref2 ? j < _ref2 : j > _ref2; 1 <= _ref2 ? j++ : j--) {
        lines.push(new Line(points[i], points[i + j]));
      }
    }
    return lines;
  };

  bestLines = (function() {
    var _i, _len, _ref, _results;
    _ref = connectTheDots(points);
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      line = _ref[_i];
      _results.push((function(line) {
        var bestLine, i, lineScore, mapping, scores, weakest, _ref2;
        lineScore = new LineScore(line, points);
        for (i = _ref2 = points.length; _ref2 <= 2 ? i <= 2 : i >= 2; _ref2 <= 2 ? i++ : i--) {
          scores = lineScore.calculate();
          mapping = (function() {
            var _ref3, _results2;
            _results2 = [];
            for (i = 0, _ref3 = lineScore.points.length - 1; 0 <= _ref3 ? i <= _ref3 : i >= _ref3; 0 <= _ref3 ? i++ : i--) {
              _results2.push(scores[i - 1] + scores[i]);
            }
            return _results2;
          })();
          weakest = mapping.indexOf(Math.min.apply(Math, _.compact(mapping)));
          if (!(((typeof bestLine !== "undefined" && bestLine !== null ? bestLine.score : void 0) != null) && scores.sum() <= bestLine.score)) {
            bestLine = {
              score: scores.sum(),
              points: lineScore.points,
              line: line
            };
          }
          if (i > 2) lineScore.remove(lineScore.points[weakest]);
        }
        return bestLine;
      })(line));
    }
    return _results;
  })();

  bestLines = _.sortBy(bestLines, function(bestLine) {
    return -bestLine.score;
  });

  for (_i = 0, _len = bestLines.length; _i < _len; _i++) {
    best = bestLines[_i];
    console.log({
      score: best.score,
      points: best.points,
      line: best.line
    });
  }

  /*
    
  #create some graphic image
  output = []
  for i in [0...10]
    row = []
    for j in [0...10]
      row.push ' '
    output.push row
  
  for point in points
    output[point.x][point.y] = '*'
  
  text = ' '
  for i in [0...10]
    text += i + ' '
  text +=  '\n'
  
  i = 0
  for op in output
    text += i++
  
    for r in op
      text += r + ' '
  
    text += '\n'
  
  console.log(text)
  */

}).call(this);
