_ = require 'underscore'

# Helper methods
Math.sqr = (n) -> n * n
Array::sum = -> @reduce ((a, b) -> a + b), 0

class exports.Point
  constructor: (@x, @y) ->
  
  distanceTo: (other) ->
    Math.sqrt Math.sqr(other.x - @x) + Math.sqr(other.y - @y)

class exports.Line
  constructor: (@p1, @p2) ->
  
  length: ->
    if _.isEqual @p1, @p2 then null else @p1.distanceTo @p2
    
  toVector: ->
    new exports.Vector @p2.x - @p1.x, @p2.y - @p1.y

class exports.Vector
  constructor: (@a, @b) ->
    
  length: ->
    Math.sqrt Math.sqr(@a) + Math.sqr (@b)
  
  @dotProduct: (v1, v2) ->
    v1.a * v2.a + v1.b * v2.b
  
  scalarProjection: (other) ->
    Vector.dotProduct(@, other) / @length()
    
  vectorProjection: (other) ->
    scalar = Vector.dotProduct(@, other) / Math.sqr(@length())    
    new Vector @a * scalar, @b * scalar
  
class exports.LineScore
  
  constructor: (@line, @points) ->
    @points = LineScore.sort @line, @points
  
  # Sort points along this line
  @sort: (line, points) ->
    _.sortBy points, (point) =>
      line.toVector().scalarProjection (new Line line.p1, point).toVector()
  
  # Calculate a score for each line segment in this line
  calculate: ->
    for i in [0...@points.length - 1]
      vector =  (new Line @points[i], @points[i + 1]).toVector()
      scalar = @line.toVector().scalarProjection vector      
      scalar / vector.length()

  remove: (point) ->
    @points = (p for p in @points when !_.isEqual p, point)

exports.solve = (points) ->
  # Solve!