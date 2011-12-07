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
    
  find: ->
    bestSolution = null
    
    for line in @lines
      score = 0
      considered = _.without @points, line.p1, line.p2
      
      while considered.length > 0
        scores = ({ point: point, distance: line.distanceTo point } for point in considered)
        lineScore = (1 / _.foldl scores, ((count, score) -> count + score.distance), 0)# / considered.length
        
        unless bestSolution? and lineScore <= bestSolution.score
          bestSolution = line: line, points: considered, score: lineScore
        
        considered = considered.remove _.max(scores, (score) -> score.distance).point

    return bestSolution