(function() {
  var Line, Point, Vector, calculateScore, connectTheDots, i, j, line, lines, n, op, output, paper, point, points, r, row, sortPoints, text, _, _i, _j, _k, _l, _len, _len2, _len3, _len4;

  _ = require('underscore');

  n = 4;

  paper = {
    width: 640,
    height: 480
  };

  Math.randInt = function(n) {
    return Math.floor(Math.random() * n);
  };

  Math.sqr = function(x) {
    return x * x;
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
      return Math.sqrt(Math.sqr(this.a + Math.sqr(this.b)));
    };

    Vector.dotProduct = function(v1, v2) {
      return v1.a * v2.a + v1.b * v2.b;
    };

    Vector.prototype.scalarProjection = function(other) {
      return Vector.dotProduct(this, other) / this.length() * other.length();
    };

    Vector.prototype.vectorProjection = function(other) {
      var scalar;
      scalar = Vector.dotProduct(this, other) / Vector.dotProduct(this, this);
      return new Vector(this.a * scalar, this.b * scalar);
    };

    return Vector;

  })();

  points = (function() {
    var _i, _results;
    _results = [];
    for (_i = 1; 1 <= n ? _i <= n : _i >= n; 1 <= n ? _i++ : _i--) {
      _results.push(new Point(Math.randInt(paper.width), Math.randInt(paper.height)));
    }
    return _results;
  })();

  points = [new Point(0, 2), new Point(8, 6), new Point(7, 1), new Point(3, 4)];

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

  calculateScore = function(line, point) {
    return 1;
  };

  sortPoints = function(line, points) {
    var vector;
    vector = line.toVector();
    return _.sortBy(points, function(point) {
      return vector.scalarProjection((new Line(line.p1, point)).toVector());
    });
  };

  lines = connectTheDots(points);

  console.log(lines);

  for (_i = 0, _len = lines.length; _i < _len; _i++) {
    line = lines[_i];
    console.log('------------------------');
    console.log(line);
    console.log(sortPoints(line, points));
    console.log('========================\n');
  }

  output = [];

  for (i = 0; i < 10; i++) {
    row = [];
    for (j = 0; j < 10; j++) {
      row.push(' ');
    }
    output.push(row);
  }

  for (_j = 0, _len2 = points.length; _j < _len2; _j++) {
    point = points[_j];
    output[point.x][point.y] = '*';
  }

  text = ' ';

  for (i = 0; i < 10; i++) {
    text += i;
  }

  text += '\n';

  i = 0;

  for (_k = 0, _len3 = output.length; _k < _len3; _k++) {
    op = output[_k];
    text += i++;
    for (_l = 0, _len4 = op.length; _l < _len4; _l++) {
      r = op[_l];
      text += r;
    }
    text += '\n';
  }

  console.log(text);

}).call(this);
