#= require lib/raphael-min
#= require lib/jquery-1.7.1.min
#= require line_detection

$ ->
  paper = new Raphael $('#canvas').offset().left, $('#canvas').offset().top, 520, 520
  raster = new Raster(paper)

  $('svg').on 'click', (e) ->
    raster.addPointByEvent e

  $('#solve').click (e) ->
    e.preventDefault()

    raster.solve()

  $('#random').click (e) ->
    e.preventDefault()

    raster.reset() if not $('#add').is ':checked'

    for i in [0..9]
      x = Math.round (Math.random() * 520)
      y = Math.round (Math.random() * 520)
      raster.addPoint x, y # && addPoint

  $('#reset').click (e) ->
    e.preventDefault()

    raster.reset()

class Raster
  constructor : (@paper) ->
    # points are defined as strings, "x,y"
    @points = []
    @circles = []

  addPointByEvent : (e) ->
    x = e.offsetX
    y = e.offsetY

    @addPoint x, y

  addPoint : (x, y) ->
    pos = $.inArray("#{x},#{y}", @points)
    if pos is -1 # not yet added
      @points.push "#{x},#{y}"

      circle = @paper.circle x, y, 5
      circle.attr 'fill', '#de3c3a'
      circle.attr 'stroke', '#de3c3a'
      
      @circles.push circle
    else # adding on the same pos removes the circle
      @removePoint pos

  addLine : (from, to) ->
    fromcsv = from.split(',')
    fromX = fromcsv[0]
    fromY = fromcsv[1]

    tocsv = to.split(',')
    toX = tocsv[0]
    toY = tocsv[1]

    line = @paper.path "M#{fromX},#{fromY} L#{toX},#{toY}"
    line.attr 'stroke', '#019edf'
    line.attr 'stroke-width', 5

  removePoint : (pos) ->
    @circles[pos].remove()

    @points.splice pos, 1
    @circles.splice pos, 1

  reset : ->
    @points = []
    @circles = []
    @circles = []
    @paper.clear()

  solve : ->
    # solution = LineDetection.solve(@points)

    # demo
    solution = [["100,100", "200,200"], "25,25"] # first entry is the line, second and forth all points belonging to that line
    @addPoint 25, 25

    @addLine solution[0][0], solution[0][1]

    # give all points that are okay a nice green color
    that = @ # withing $.each this refers to currentElem
    $.each solution, (index, value) ->
      pos = $.inArray value, that.points

      if pos isnt -1
        that.circles[pos].attr 'fill', 'green'
        that.circles[pos].attr 'stroke', 'green'