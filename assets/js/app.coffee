#= require lib/jquery-1.7.1.min
#= require lib/raphael-min
#= require line_detection

$ ->
  $('#eraser').click -> false
  
  canvas = new Canvas($('#canvas'))
  
  $(window).resize ->
    canvas.resize()
    canvas.redraw()
        
class Canvas
  
  constructor: (@canvas) ->
    @canvas.mousemove (event) =>
      @redraw event
    
    @canvas.mouseleave (event) =>
      @clear()
      
    @context = @canvas.get(0).getContext('2d')
    @resize()
    
  resize: ->
    @canvas.attr('width', $('#region').width() - 40)
  
  redraw: (event) ->
    @clear()  
    @drawCursor(event)
    
  clear: ->
    @context.clearRect 0, 0, @canvas.width(), @canvas.height()
    
  drawCursor: (event, radius = 8, alpha = 0.3) ->
    x = event.pageX - @canvas.offset().left
    y = event.pageY - @canvas.offset().top
    
    @context.fillStyle = "rgba(0, 0, 0, " + alpha + ")"
    @context.beginPath()
    @context.arc(x, y, radius, 0, Math.PI * 2, true)
    @context.closePath()
    @context.fill()