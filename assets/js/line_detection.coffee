#= require lib/underscore-min
_ = require 'underscore' if require?

exports ?= window

Math.sqr = (n) -> n * n
Array::sum = -> @reduce ((a, b) -> a + b), 0
Array::remove = (e...) -> _.without @, e...
Array::add = (e...) -> @concat e...

exports.Point = class Point
  constructor: (@x, @y) ->
  
  distanceTo: (other) ->
    Math.sqrt Math.sqr(other.x - @x) + Math.sqr(other.y - @y)

exports.Line = class Line
  constructor: (@p1, @p2) ->
  
  length: ->
    @p1.distanceTo @p2
    
  toVector: ->
    new exports.Vector @p2.x - @p1.x, @p2.y - @p1.y

exports.Vector = class Vector
  constructor: (@a, @b) ->
    
  length: ->
    Math.sqrt Math.sqr(@a) + Math.sqr (@b)
  
  @dotProduct: (v1, v2) ->
    v1.a * v2.a + v1.b * v2.b
  
  scalarProjection: (other) ->
    Vector.dotProduct(@, other) / @length()
    
  vectorProjection: (other) ->
    # Watch out for precision loss with (√x)²
    scalar = Vector.dotProduct(@, other) / (Math.sqr(@a) + Math.sqr(@b))
    new Vector @a * scalar, @b * scalar

exports.solve = solve = (points) ->
  
  for i in [0...points.length - 1]
    for j in [1...points.length - i]
      p1 = points[i]
      p2 = points[i + j]

      for [p1, p2] in [[p1, p2], [p2, p1]]
        considered = _.without points, p1, p2
        
        result = [p1, p2]
        
        for p in considered
          best = p
          
          # Compare with current line segment chain?
          
        considered = considered.remove best
        result = result.add p