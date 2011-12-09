#= require lib/underscore-min

exports ?= window
_       ?= require 'underscore'

Math.sqr = (n) -> n * n
Array::sum = -> @reduce ((a, b) -> a + b), 0
Array::remove = (e...) -> _.without @, e...
Array::add = (e...) -> @concat e...

exports.Point = class Point
  constructor: (@x, @y) ->
  
  distanceTo: (other) ->
    Math.sqrt Math.sqr(other.x - @x) + Math.sqr(other.y - @y)

  translateBy: (vector) ->
    new Point(@x + vector.a, @y + vector.b)

exports.Line = class Line
  constructor: (@p1, @p2) ->
  
  length: ->
    @p1.distanceTo @p2
    
  toVector: ->
    new Vector(@p2.x - @p1.x, @p2.y - @p1.y)
  
  distanceTo: (point) ->
    projection = @toVector().vectorProjection (new Line @p1, point).toVector()
    point.distanceTo @p1.translateBy(projection)

exports.Vector = class Vector
  constructor: (@a, @b) ->
    
  length: ->
    Math.sqrt Math.sqr(@a) + Math.sqr (@b)
  
  @dotProduct: (v1, v2) ->
    v1.a * v2.a + v1.b * v2.b
  
  scalarProjection: (other) ->
    Vector.dotProduct(@, other) / @length()
    
  vectorProjection: (other) ->
    scalar = Vector.dotProduct(@, other) / (Math.sqr(@a) + Math.sqr(@b))
    new Vector @a * scalar, @b * scalar

exports.Solution = class Solution
  constructor: (@points) ->
    @lines = @determineLines()

  determineLines: ->
    lines = []
    for i in [0...@points.length - 1]
      for j in [1...@points.length - i]
        lines.push new Line @points[i], @points[i + j]
    lines
    
  sortPoints: (line) ->
    _.sortBy @points, (point) ->
      line.toVector().scalarProjection (new Line line.p1, point).toVector()
    
  find: ->    
    for line in @lines      
      # Sort considered points along line
      considered = @sortPoints(line)
      
      # Repeat till only line.p1 and line.p2 are left
      while considered.length > 2
        
        # Initial score for all points is zero
        scores = (0 for i in [0...considered.length])
        
        for i in [0...considered.length - 1]
          for j in [0..1]
            point = considered[i + j]
            other = considered[i + (1 - j)]
            projection = line.toVector().scalarProjection (new Line point, other).toVector()
            distance = point.distanceTo other
            score = Math.round(Math.abs(projection) - distance)
            scores[i + j] += score
            
            # Assign score twice to start and end points
            scores[i + j] *= 2 if ((i + j) % considered.length - 1) == 0
            
            # Make sure that line.p1 and line.p2 never have the lowest score
            scores[i + j] = Infinity if (considered[i + j] is line.p1 || considered[i + j] is line.p2)
        
        linescore = _(scores).without(Infinity).sum()
        
        # Decide whether this is the best solution so far        
        unless bestSolution? and linescore <= bestSolution.score
          bestSolution = score: linescore, points: considered, line: line

        # Remove the point that deviates the most
        considered = considered.remove considered[scores.indexOf Math.min(scores...)]

    return bestSolution