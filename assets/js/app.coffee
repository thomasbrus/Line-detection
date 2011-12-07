#= require lib/jquery-1.7.1.min
#= require lib/raphael-min
#= require line_detection

$ ->
  canvas = new Canvas($('#canvas'))
  
  $(window).resize ->
    canvas.resize()
    canvas.redraw()
    
  $('#canvas').one 'click', -> $('#placeholder').fadeOut 'slow'
    
  $('#eraser').click ->
    canvas.clear(true)
    false

class Canvas
  
  constructor: (@canvas) ->
    @points = []
        
    @context = @canvas.get(0).getContext('2d')
    
    @canvas.mousemove (event) =>
      @redraw event
    
    @canvas.mouseleave (event) =>
      @redraw()
      
    @canvas.click (event) =>
      x     = @mouseX event
      y     = @mouseY event
      alpha = Math.random() * 0.3 + 0.5
      @addPoint x, y, alpha
      @drawPoint x, y, alpha
      
    @resize()
  
  resize: ->
    @canvas.attr('width', $('#region').width() - 40)
  
  redraw: (event) ->
    @clear()
    @drawPoint p.x, p.y, p.alpha for p in @points
    @drawCursor @mouseX(event), @mouseY(event) if event?
    
  mouseX: (event) ->
    event.pageX - @canvas.offset().left
  
  mouseY: (event) ->
    event.pageY - @canvas.offset().top
  
  clear: (all) ->
    @points = [] if all?
    @context.clearRect 0, 0, @canvas.width(), @canvas.height()
    
  drawCursor: (x, y, radius = 8, alpha = 0.2) ->
    @drawCircle(x, y, radius, "rgba(0, 0, 0, " + alpha + ")")
    
  drawPoint: (x, y, alpha) ->
    @drawCircle(x, y, 4, "white")
    @drawCircle(x, y, 3, "rgba(0, 0, 0, " + alpha + ")", "rgba(0, 0, 0, " + (alpha / 4) + ")")
    
  drawCircle: (x, y, radius, fill, stroke) ->
    @context.fillStyle = fill
    @context.strokeStyle = stroke if stroke?
    @context.beginPath()
    @context.arc(x, y, radius, 0, Math.PI * 2, true)
    @context.closePath()
    @context.fill()
    @context.stroke() if stroke?
  
  addPoint: (x, y, alpha) ->
    @points.push { x: x, y: y, alpha: alpha }