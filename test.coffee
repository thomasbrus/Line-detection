_ = require 'underscore'

# Number of points
n = 4

paper =
  width:  640
  height: 480

class Point
  constructor: (@x, @y) ->
  
  distanceTo: (other) ->
    Math.sqrt Math.sqr(other.x - @x) + Math.sqr(other.y - @y)

class Line
  constructor: (@p1, @p2) ->
    
  toVector: ->
    Vector @p2.x - @p1.x, @p2.y - @p1.y

class Vector
  constructor: (@a, @b) ->
    
  length: ->
    Math.sqrt Math.sqr @a + Math.sqr @b

  angle: ->
    (180 / Math.PI) * Math.atan2 @a, @b
    
  alpha: -> (180 / Math.PI) * Math.acos(@a / @length)
  beta: ->  (180 / Math.PI) * Math.acos(@b / @length)
  
  directionAngles: ->
    alpha:  @alpha
    beta:   @beta
    
  @angle: (v1, v2) ->
    (180 / Math.PI) * Math.acos(Vector.dotProduct v1, v2 / (v1.length * v2.length))
  
  @dotProduct: (v1, v2) ->
    v1.a * v2.a + v1.b * v2.b
    
  # Scalar projection of (b) onto (a)
  scalarProjection: (other) ->
    Vector.dotProduct @, other / @length
  
  # Vector projection of (b) onto (a)
  vectorProjection: (other) ->
    scalar = Vector.dotProduct @, other / Math.sqr @length
    new Vector @a * scalar, @b * scalar


Math.randInt = (n) ->
  Math.floor(Math.random() * n)

Math.sqr = (x) -> x * x

# Generate n random points
points = for [1..n]
  new Point Math.randInt(paper.width), Math.randInt(paper.height)

# Find all (n choose 2) lines
connectTheDots = (points) ->
  for i in [0...n - 1]
    for j in [i + 1...n]
      new Line points[i], points[j]

calculateScore = (line, point) ->
  true
  #hypotenuse  =
  #adjacent    =
  #opposite    =
  
  #adjacent - opposite

sortPoints = (line, points) ->
  #chosen = [line.p1, line.p2] 
  #considered = _.difference points, chosen
  
  # 1) Project the vector from (line.p1) to p onto the vector of (line).
  #vector = line.toVector
  #projections = for p in considered
  #  { point: p, scalar: vector.scalarProjection new Vector p.x - line.p1.x, p.y - line.p1.y }
  
  # 2) Sort projections by scalar in order to "walk the line"
  #_.sortBy projections, (projection) ->
  #  projection.scalar
    
  # Alternative?
  vector = line.toVector
  _.sortBy points, (point) ->
    if point is line.p1
      0
    else if point is line.p2
      line.p1.distanceTo line.p2
    else
      vector.scalarProjection new Vector point.x - line.p1.x, point.y - line.p1.y
  
  # Walk through the points pairwise
  #for i in [0...points.length]
    #point: points[j], score: calculateScore line, points[j] for j in [i..i + 1]
    
  #intersections.push p1, p2
  #_.sortBy intersections, (intersection) ->
    # length(vector, intersection.intersection)

  # 3) Loop paarsgewijs door de snijpunten heen.
  #for i in [0...intersections.length]
    
    # 4) Ken telkens beide punten een score toe: aanliggende zijde - overstaande zijde.
    #    De begin en eindpunten krijgen één score toegewezen, de andere punten twee.
    
    #console.log(intersections[i], intersections[i + 1])
 
  ### 
  
  Een hogere score is beter. Tel alle scores bij elkaar op om de score van
  een lijn door de verzameling van deze punten te bepalen. Verwijder nu het punt
  met de laagste score uit consideredPoints en herbereken de score (alleen nodig
  bij het punt dat na het verwijderde punt komt en het punt dat ervoor zit). Ga
  door totdat de hoogste score is gevonden (*).
  
  ###

#lines = (walkTheLine points, p1, p2 for [p1, p2] in connectTheDots points)

lines = connectTheDots points
sortedPoints = [line, sortPoints line, points] for line in lines

#chosenPoints = for line in lines
  # do
  # lineScore line, points
  # points.remove(p)
  # until highest score is found
  # return line + selected points



