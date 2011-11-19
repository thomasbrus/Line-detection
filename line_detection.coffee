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
    
  toVector: ->
    new Vector(@p2.x - @p1.x, @p2.y - @p1.y)

class Vector
  constructor: (@a, @b) ->
    
  length: ->
    Math.sqrt Math.sqr @a + Math.sqr @b
  
  @dotProduct: (v1, v2) ->
    v1.a * v2.a + v1.b * v2.b
    
  # Scalar projection of [other] onto [this]
  scalarProjection: (other) ->
    Vector.dotProduct(@, other) / @length() * other.length()
    
  # Vector projection of [other] onto [this]
  vectorProjection: (other) ->
    scalar = Vector.dotProduct(@, other) / Vector.dotProduct(@, @)
    new Vector(@a * scalar, @b * scalar)

class LineScore
  
  constructor: (@line, @points) ->
    @points = _.sortBy points, (point) => @line.toVector().scalarProjection (new Line line.p1, point).toVector()
    
  calculate: ->
    weakestPoint
    lowestScore
    totalScore = 0
    
    # Walk through points pairwise
    for i in [0...@points.length - 1]
      v1 = @line.toVector().vectorProjection (new Line line.p1, @points[i]).toVector()
      v2 = @line.toVector().vectorProjection (new Line line.p1, @points[i + 1]).toVector()

      # Points projected on line
      pp1 = new Point line.p1.x - v1.a, line.p1.y - v1.b 
      pp2 = new Point line.p1.x - v2.a, line.p1.y - v2.b

      # Vectors from projected points to points
      vectors = [(new Line pp2, points[i]).toVector(), (new Line pp1, @points[i + 1]).toVector()]
      
      for vector, j in vectors
        score = vector.scalarProjection(@line.toVector()) / Math.sqr vector.length()
        
        unless lowestScore? and score >= lowestScore
          lowestScore = score
          weakestPoint = @points[i + j]
        
        totalScore += score
        
    total:    totalScore
    weakest:  weakestPoint
    
  removePoint: (point) ->
    @points = (p for p in @points when !_.isEqual p, point)

# Generate n random points
points = for [1..n]
  new Point Math.randInt(paper.width), Math.randInt(paper.height)

# points = [
#   new Point 0, 2
#   new Point 8, 6
#   new Point 7, 1
#   new Point 3, 4
# ]

# Find all (n choose 2) lines
connectTheDots = (points) ->
  # Comprehension problems.. http://brehaut.net/blog/2011/coffeescript_comprehensions
  lines = []
  for i in [0...points.length - 1]
    for j in [1...points.length - i]
      lines.push new Line(points[i], points[i + j])
  lines

for line in connectTheDots points
  console.log 'Examaning line', line
  console.log '----------------------------------------\n'
  lineScore = new LineScore line, points
  
  while lineScore.points.length >= 2
    result = lineScore.calculate()
    console.log 'Points', lineScore.points
    console.log 'Score', result.total
    console.log 'Weakest point', result.weakest
    lineScore.removePoint result.weakest
    console.log ''
  
  console.log '----------------------------------------\n'


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
