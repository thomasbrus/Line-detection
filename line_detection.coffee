_ = require 'underscore'

# Number of points
n = 4

paper =
  width:  640
  height: 480

Math.randInt = (n) ->
  Math.floor Math.random() * n

Math.sqr = (x) -> x * x

class Point
  constructor: (@x, @y) ->
  
  distanceTo: (other) ->
    Math.sqrt Math.sqr(other.x - @x) + Math.sqr(other.y - @y)

class Line
  constructor: (@p1, @p2) ->
    
  toVector: ->
    new Vector(@p2.x - @p1.x, @p2.y - @p1.y)

class Vector
  constructor: (@a, @b) ->
    
  length: ->
    Math.sqrt Math.sqr @a + Math.sqr @b

  @dotProduct: (v1, v2) ->
    v1.a * v2.a + v1.b * v2.b
    
  # Scalar projection of (b) onto (a)
  scalarProjection: (other) ->
    Vector.dotProduct(@, other) / @length() * other.length()
    
  # Vector projection of (b) onto (a)
  vectorProjection: (other) ->
    scalar = Vector.dotProduct(@, other) / Vector.dotProduct(@, @)
    new Vector(@a * scalar, @b * scalar)

# Generate n random points
points = for [1..n]
  new Point Math.randInt(paper.width), Math.randInt(paper.height)

points = [
  new Point 0, 2
  new Point 8, 6
  new Point 7, 1
  new Point 3, 4
]

# Find all (n choose 2) lines
connectTheDots = (points) ->
  # Comprehension problems.. http://brehaut.net/blog/2011/coffeescript_comprehensions
  lines = [] 
  for i in [0..points.length - 2]
    for j in [1...points.length - i]
      lines.push new Line(points[i], points[i + j])
  lines
  
calculateScore = (line, point) ->
  #hypotenuse  =
  #adjacent    =
  #opposite    =
  
  #adjacent - opposite
  
  1

sortPoints = (line, points) ->  
  # Look at this line as a vector
  vector = line.toVector()
  
  # Sort points by the scalar projection of (the line from line.p1 to point as vector) onto (vector)
  _.sortBy points, (point) ->
      vector.scalarProjection((new Line line.p1, point).toVector())
            
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
console.log lines

for line in lines
  console.log '\n------------------------'
  console.log line
  console.log sortPoints line, points
  console.log '========================\n'
