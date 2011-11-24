vows                    = require 'vows'
assert                  = require 'assert'
_                       = require 'underscore'
{Point, Line, Vector}   = require '../assets/js/line_detection'

createLine = (x1, y1, x2, y2) ->
  new Line (new Point x1, y1), (new Point x2, y2)

vows
  .describe('Length of a line')
  .addBatch
    'A line from (-10, -10) to (20, 20)':
      topic: -> createLine -10, -10, 20, 20

      'should have length √1800': (topic) ->
        assert.equal topic.length(), Math.sqrt 1800
      
      'should translate to the vector <30, 30>': (topic) ->
        vector = topic.toVector()
        assert.equal vector.a, 30
        assert.equal vector.b, 30

    'And a line from (20, 20) to (-10, -10)':
      topic: -> createLine 20, 20, -10, -10

      'should also have length √1800': (topic) ->
        assert.equal topic.length(), Math.sqrt 1800
        
      'should translate to the vector <-30, -30>': (topic) ->
        vector = topic.toVector()
        assert.equal vector.a, -30
        assert.equal vector.b, -30
                    
    'But a line from (0, 0) to (0, 0)':
      topic: -> createLine 0, 0, 0, 0
        
      'should not have a length': (topic) ->
        assert.isNull topic.length()
        
      'should translate to the null vector': (topic) ->
        vector = topic.toVector()
        assert.equal vector.a, 0
        assert.equal vector.b, 0
        
  .export(module)