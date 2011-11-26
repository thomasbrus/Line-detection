header ->
  h1 'Line Detection Demonstration'

p 'Click to add some points on this raster and solve to get the Line Detection-line.'

form ->
  button id: 'solve', 'Solve!'
  button id: 'random', 'Random!'
  input type: 'checkbox', id: 'add'
  label for: 'add', '+'
  button id: 'reset', 'I screwed up, sorry!'

table ->
  for i in [1..20]
    tr ->
      for i in [1..20]
        td '&nbsp;'