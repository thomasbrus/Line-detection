_ = require 'underscore'

# Number of points
n = 6

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
  
  length: ->
    Math.sqrt Math.sqr(@p2.x - @p1.x) + Math.sqr(@p2.y - @p1.y)
  
  distanceTo: (point) ->
    #distance = Vector.crossProduct(@toVector(), (new Line @p1, point).toVector()) / @length()
    1
  
  toVector: ->
    new Vector(@p2.x - @p1.x, @p2.y - @p1.y)

class Vector
  constructor: (@a, @b) ->
    
  length: ->
    Math.sqrt Math.sqr @a + Math.sqr @b
  
  @dotProduct: (v1, v2) ->
    v1.a * v2.a + v1.b * v2.b
  
  @crossProduct: (v1, v2) ->
    v1.a * v2.b - v1.b * v2.a  
  
  # Scalar projection of [other] onto [this]
  scalarProjection: (other) ->
    Vector.dotProduct(@, other) / @length()
    
  # Vector projection of [other] onto [this]
  vectorProjection: (other) ->
    scalar = Vector.dotProduct(@, other) / Vector.dotProduct(@, @)
    new Vector(@a * scalar, @b * scalar)
  
class LineScore
  
  constructor: (@line, @points) ->
    @points = LineScore.sort @line, @points
  
  @sort: (line, points) ->
    _.sortBy points, (point) =>
      line.toVector().scalarProjection (new Line line.p1, point).toVector()
  
  calculate: ->
    totalScore = 0
    
    # Walk through points
    for i in [0...@points.length - 1]
      vector =  (new Line @points[i], @points[i + 1]).toVector()
      scalar = @line.toVector().scalarProjection vector      
      score = scalar / vector.length()
      
      unless lowestScore? and score >= lowestScore
        lowestScore = score
                
      totalScore += score
      
    totalScore
    
  removePoint: (point) ->
    @points = (p for p in @points when !_.isEqual p, point)

# Generate n random points
points = for [1..n]
  new Point Math.randInt(paper.width), Math.randInt(paper.height)

points = [
  new Point 0, 0
  new Point 4, 4
  new Point 6, 0
  new Point 10, 0
]

# Find all (n choose 2) lines
connectTheDots = (points) ->
  # Comprehension problems.. http://brehaut.net/blog/2011/coffeescript_comprehensions
  lines = []
  for i in [0...points.length - 1]
    for j in [1...points.length - i]
      lines.push new Line(points[i], points[i + j])
  lines

for line in [new Line points[0], points[points.length - 1]] #connectTheDots points
  console.log '=========================================='
  console.log 'Checking line', line
  console.log '----------------------------------------\n'
  lineScore = new LineScore line, points
  
  while lineScore.points.length >= 2
    score = lineScore.calculate()
    console.log 'Points', lineScore.points
    console.log 'Score', score
    lineScore.removePoint lineScore.points[1]

###
  
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

###
