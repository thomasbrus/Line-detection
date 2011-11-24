vows      = require 'vows'
assert    = require 'assert'
{Point}   = require '../assets/js/line_detection'

distance = (x1, y1, x2, y2) ->
  (new Point x1, y1).distanceTo (new Point x2, y2)
  
vows
  .describe('Distance between two points')
  .addBatch
    'The distance between (-10, -10) and (20, 20)':
      topic: -> distance -10, -10, 20, 20

      'should be √1800': (topic) ->
        assert.equal topic, Math.sqrt 1800

    'And the distance between (20, 20) and (-10, -10)':
      topic: -> distance 20, 20, -10, -10

      'should also be √1800': (topic) ->
        assert.equal topic, Math.sqrt 1800
        
    'But the distance to itself':
      topic: -> distance 10, 10, 10, 10

      'should be zero': (topic) ->
        assert.equal topic, 0

  .export(module)