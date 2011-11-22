#= require raphael
#= require jquery-1.7.1
#= require line_detection

$ ->
  # Do jQuery (and Raphael) stuff here
  
findSolution = ->
  (new LineDetection points).solve()