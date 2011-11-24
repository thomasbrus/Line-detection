vows        = require 'vows'
assert      = require 'assert'
{Vector}    = require '../assets/js/line_detection'

dotProduct = (topics) ->
  Vector.dotProduct topics[0], topics[1]

scalarProjection = (topics) ->
  topics[0].scalarProjection topics[1]
  
vectorProjection = (topics) ->
  topics[0].vectorProjection topics[1]

vows.describe('Vector')

  .addBatch
    'A vector ⟨10, 20⟩':
      topic: -> new Vector 10, 20

      'should have length √500': (topic) ->
        assert.equal topic.length(), Math.sqrt 500
      
      'and ⟨-20,10⟩':
        topic: -> new Vector -20, 10
        
        'should have a dot product of 0': ->
          assert.equal dotProduct(@context.topics), 0
      
      # Projection along x-axis
      'projected on ⟨100, 0⟩':
        topic: -> new Vector 100, 0

        'should give the scalar 10': ->
          assert.equal scalarProjection(@context.topics), 10

        'should give the vector ⟨10, 0⟩': ->
          assert.deepEqual vectorProjection(@context.topics), (new Vector 10, 0)
          
      # Projection along y-axis
      'projected on ⟨0, 200⟩':
        topic: -> new Vector 0, 200
        
        'should give the scalar 20': ->
          assert.equal scalarProjection(@context.topics), 20
        
        'should give the vector ⟨0, 20⟩': ->
          assert.deepEqual vectorProjection(@context.topics), (new Vector 0, 20)
  
  .addBatch
    'A vector ⟨-4, 5⟩ ':
      topic: -> new Vector -4, 5

      'should have length √41': (topic) ->
        assert.equal topic.length(), Math.sqrt 41
      
      'and ⟨3, -4⟩':
        topic: -> new Vector 3, -4
        
        'should have a dot product of -32': ->
          assert.equal dotProduct(@context.topics), -32
      
      'projected on ⟨1, 9⟩':
        topic: -> new Vector 1, 9
 
        # dotProduct  = -4 * 1 + 5 * 9 = 41
        # length      = 1 + 81 = √82
        
        # =======================================
        
        # Vector.dotProduct(@, other) / @length()
        'should give the scalar 41 / √82': ->
          assert.equal scalarProjection(@context.topics), 41 / Math.sqrt 82
        
        # scalar = Vector.dotProduct(@, other) / Math.sqr(@length())
        # new Vector @a * scalar, @b * scalar        
        'should give the vector ⟨0.5, 5.5⟩': (topic) ->
          scalar = 41 / 82
          vector = new Vector topic.a * scalar, topic.b * scalar
          assert.deepEqual vectorProjection(@context.topics), vector

  .addBatch
    'A vector ⟨-10, -10⟩':
      topic: -> new Vector -10, -10

      'should have length √200': (topic) ->
        assert.equal topic.length(), Math.sqrt 200

      'and a vector ⟨20,20⟩':
        topic: -> new Vector 20, 10

        'should have a dot product of -300': ->
          assert.equal dotProduct(@context.topics), -300
  
  .export(module)
