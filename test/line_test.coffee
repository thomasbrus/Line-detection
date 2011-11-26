vows                    = require 'vows'
assert                  = require 'assert'
{Point, Line, Vector}   = require '../assets/js/line_detection'

createLine = (x1, y1, x2, y2) ->
  new Line (new Point x1, y1), (new Point x2, y2)  

vows.describe('Line')
  
  .addBatch
    'A line from (-10, -10) to (20, 20)':
      topic: -> createLine -10, -10, 20, 20

      'should have length √1800': (topic) ->
        assert.equal topic.length(), Math.sqrt 1800
      
      'should translate to the vector ⟨30, 30⟩': (topic) ->
        assert.deepEqual topic.toVector(), (new Vector 30, 30)

  .addBatch
    'And a line from (20, 20) to (-10, -10)':
      topic: -> createLine 20, 20, -10, -10

      'should also have length √1800': (topic) ->
        assert.equal topic.length(), Math.sqrt 1800
        
      'should translate to the vector ⟨-30, -30⟩': (topic) ->
        assert.deepEqual topic.toVector(), (new Vector -30, -30)
        
  .export(module)