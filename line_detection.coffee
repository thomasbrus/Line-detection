_ = require 'underscore'

{inspect} = require 'util'

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
    
  # Scalar projection of [other] onto [this]
  scalarProjection: (other) ->
    Vector.dotProduct(@, other) / @length() * other.length()
    
  # Vector projection of [other] onto [this]
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
  for i in [0...points.length - 1]
    for j in [1...points.length - i]
      lines.push new Line(points[i], points[i + j])
  lines


calcScoreAndRemovePoint = (line, points) ->
  score = 0
  
  # Look at the line as a vector
  vector = line.toVector()
  
  # Sort points by the scalar projection of (the line from [line.p1] to [point] as vector) onto [vector]
  _.sortBy points, (point) ->
      vector.scalarProjection (new Line line.p1, point).toVector()
      
  # Walk through points pairwise
  for i in [0...points.length - 1]
    v1 = vector.vectorProjection (new Line line.p1, points[i]).toVector()
    v2 = vector.vectorProjection (new Line line.p1, points[i + 1]).toVector()
    
    p1 = new Point line.p1.x - v1.a, line.p1.y - v1.b 
    p2 = new Point line.p1.x - v2.a, line.p1.y - v2.b
    
    for [a, b] in [[p2, points[i]], [p1, points[i + 1]]]    
      s = (new Line a, b).toVector().scalarProjection vector
      if s > lastS
        pointToRemove = a # of b?
      score += new Line a,b .lenght - s
  
  [score, points]
  
lines = connectTheDots points

scores = (calculateScores(line, points) for line in lines)

for score in scores
  console.log score[0], score[1]

for line in lines
  console.log '------------------------------------------------------------------'
  console.log line
  console.log sortPoints line, points
  console.log '==================================================================\n'
  
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
  text += i
text +=  '\n'

i = 0
for op in output
  text += i++

  for r in op
    text += r

  text += '\n'

console.log(text)