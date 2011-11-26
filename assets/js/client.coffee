#= require raphael
#= require jquery-1.7.1
#= require line_detection

$ ->
  $('td').click ->
    if not $(this).hasClass 'selected'
      $(this).addClass 'selected'
      # should add point to array
      #addPoint this
    else
      $(this).removeClass 'selected'
      # should remove point from array
      #removePoint this

findSolution = ->
  solution = LineDetection.solve(points)