_ = require 'underscore'

# Number of points
n = 6

paper =
  width:  640
  height: 480

Math.randInt = (n) ->
  Math.floor Math.random() * n

Math.sqr = (n) -> n * n

Array::sum = -> @reduce ((a, b) -> a + b), 0

class Point
  constructor: (@x, @y) ->
  
  distanceTo: (other) ->
    Math.sqrt Math.sqr(other.x - @x) + Math.sqr(other.y - @y)

class Line
  constructor: (@p1, @p2) ->
  
  length: ->
    Math.sqrt Math.sqr(@p2.x - @p1.x) + Math.sqr(@p2.y - @p1.y)
    
  toVector: ->
    new Vector(@p2.x - @p1.x, @p2.y - @p1.y)

class Vector
  constructor: (@a, @b) ->
    
  length: ->
    Math.sqrt Math.sqr(@a) + Math.sqr (@b)
  
  @dotProduct: (v1, v2) ->
    v1.a * v2.a + v1.b * v2.b
  
  scalarProjection: (other) ->
    Vector.dotProduct(@, other) / @length()
    
  vectorProjection: (other) ->
    scalar = Vector.dotProduct(@, other) / Vector.dotProduct(@, @)
    new Vector(@a * scalar, @b * scalar)
  
class LineScore
  
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

# Generate n random points
points = for [1..n]
  new Point Math.randInt(paper.width), Math.randInt(paper.height)

points = [
  new Point 5, 0
  new Point 5, 5
  new Point 5, 10
]

v1 = new Vector 0, 5
v2 = new Vector 4, 4

console.log v1.length(), v2.length(), v1.scalarProjection v2

# Find all (n choose 2) lines
connectTheDots = (points) ->
  # Comprehension problems.. http://brehaut.net/blog/2011/coffeescript_comprehensions
  lines = []
  for i in [0...points.length - 1]
    for j in [1...points.length - i]
      lines.push new Line(points[i], points[i + j])
  lines

# Loop through all lines a.k.a. sets of two points
bestLines = 
  for line in connectTheDots points
  
    do (line) ->
      lineScore = new LineScore line, points
    
      # Calculate score and remove the weakest point (points.length - 2) times
      for i in [points.length..2]
        scores = lineScore.calculate()
        mapping = (scores[i - 1] + scores[i] for i in [0..lineScore.points.length - 1])
        weakest = mapping.indexOf Math.min _.compact(mapping)...
    
        unless bestLine?.score? and scores.sum() <= bestLine.score
          # Store current best score
          bestLine = score: scores.sum(), points: lineScore.points, line: line
    
        # Remove the point with the lowest score
        lineScore.remove lineScore.points[weakest] if i > 2

      bestLine

bestLines = _.sortBy bestLines, (bestLine) -> -bestLine.score
console.log (score: best.score, points: best.points, line: best.line) for best in bestLines

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
