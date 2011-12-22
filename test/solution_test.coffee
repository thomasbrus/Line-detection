vows                    = require 'vows'
assert                  = require 'assert'
{Point, Line, Solution} = require '../assets/js/line_detection'

p1 = new Point 0, 1
p2 = new Point 2, 3
p3 = new Point 4, 5
p4 = new Point 6 ,7

createSolution = (points) ->
  new Solution points

vows.describe('Solution')
  
  .addBatch
    'The set of possible lines between points [0, 1], [2, 3], [4, 5] and [6, 7]':
      topic: -> createSolution [p1, p2, p3, p4]

      'should be of length 6': (topic) ->
        assert.equal topic.allLines().length, 6
    
      'should consist of [p1, p2], [p1, p3], [p1, p4], [p2, p3], [p2, p4] and [p3, p4]': (topic) ->
        assert.deepEqual topic.allLines(), [
          new Line p1, p2
          new Line p1, p3
          new Line p1, p4
          new Line p2, p3
          new Line p2, p4
          new Line p3, p4
        ]
        
  .export(module)