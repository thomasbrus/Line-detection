#= require lib/jquery-1.7.1.min
#= require lib/raphael-min
#= require line_detection

$ ->
  resizeCanvas()
  $('#eraser').click -> false
  $(window).resize resizeCanvas
  
resizeCanvas = ->
  console.log 'bla'
  $('#canvas').attr('width', $('#region').width() - 40)