#= require lib/raphael-min
#= require lib/jquery-1.7.1.min
#= require line_detection

$ ->
  $('td').click ->
    if not $(@).hasClass 'selected'
      addPoint @
      # should add point to array
      # addPoint this
    else
      removePoint @
      # should remove point from array
      # removePoint this

  $('#solve').click (e) ->
    e.preventDefault()

    resetRaster()
    findSolution()

  $('#random').click (e) ->
    e.preventDefault()

    resetRaster(not $('#add').is ':checked')
    $('td').each (index, value) ->
      addPoint @ if(Math.random() < .01) # && addPoint

  $('svg').live 'click', ->
    resetRaster()

  $('#reset').click (e) ->
    e.preventDefault()

    resetRaster(true)

resetRaster = (removePoints) ->
  $('table').removeClass 'solve'
  $('svg').remove()

  if(removePoints)
    $('td').each (index, value) ->
      removePoint @
      # removePoint this

addPoint = (elem) ->
  $(elem).addClass 'selected'
  # add to array

removePoint = (elem) ->
  $(elem).removeClass 'selected'
  # remove from array

findSolution = ->
  # solution = LineDetection.solve(points)
  $('table').addClass 'solve'
  paper = new Raphael $('table').offset().left, $('table').offset().top, 520, 520
  line = paper.path 'M0 0L520 520'
  line.attr { stroke: '#019edf', 'stroke-width': 2 }